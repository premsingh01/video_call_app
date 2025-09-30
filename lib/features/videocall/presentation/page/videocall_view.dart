import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call_app/core/utils/agora_config.dart';



class VideocallView extends StatefulWidget {
  const VideocallView({super.key});

  @override
  State<VideocallView> createState() => _VideocallViewState();
}

class _VideocallViewState extends State<VideocallView> {
  late final RtcEngine _engine;
  int? _remoteUid;
  bool _isJoined = false;
  bool _micMuted = false;
  bool _videoOff = false;
  bool _isScreenSharing = false;
  bool _engineReady = false;

  @override
  void initState() {
    super.initState();
    // Create engine synchronously to avoid LateInitializationError in build
    _engine = createAgoraRtcEngine();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    await _engine.initialize(const RtcEngineContext(appId: AgoraConfig.appId));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        setState(() {
          _isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        setState(() {
          _remoteUid = remoteUid;
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        setState(() {
          _remoteUid = null;
        });
      },
    ));

    await _engine.enableVideo();
    await _engine.startPreview();
    if (mounted) {
      setState(() {
        _engineReady = true;
      });
    }

    await _engine.joinChannel(
      token: AgoraConfig.token,
      channelId: AgoraConfig.channel,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _toggleMic() async {
    _micMuted = !_micMuted;
    await _engine.muteLocalAudioStream(_micMuted);
    setState(() {});
  }

  Future<void> _toggleVideo() async {
    _videoOff = !_videoOff;
    await _engine.muteLocalVideoStream(_videoOff);
    if (_videoOff) {
      await _engine.stopPreview();
    } else {
      await _engine.startPreview();
    }
    setState(() {});
  }

  Future<void> _toggleScreenShare() async {
    // Android screen share via media projection (requires Android 10+ for foreground service types)
    _isScreenSharing = !_isScreenSharing;
    if (_isScreenSharing) {
      await _engine.startScreenCapture(
        ScreenCaptureParameters2(
          captureAudio: true,
          audioParams: const ScreenAudioParameters(
            sampleRate: 48000,
            channels: 2,
            captureSignalVolume: 100,
          ),
          videoParams: const ScreenVideoParameters(
            frameRate: 15,
            bitrate: 1200,
            dimensions: VideoDimensions(width: 1280, height: 720),
          ),
        ),
      );
      await _engine.updateChannelMediaOptions(const ChannelMediaOptions(
        publishScreenCaptureVideo: true,
        publishCameraTrack: false,
        publishMicrophoneTrack: true,
        publishScreenCaptureAudio: true,
      ));
    } else {
      await _engine.updateChannelMediaOptions(const ChannelMediaOptions(
        publishScreenCaptureVideo: false,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        publishScreenCaptureAudio: false,
      ));
      await _engine.stopScreenCapture();
    }
    setState(() {});
  }

  Future<void> _endCall() async {
    await _engine.leaveChannel();
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    _engine.stopPreview();
    _engine.release();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Remote view full screen
            Positioned.fill(
              child: !_engineReady
                  ? const SizedBox.shrink()
                  : _remoteUid != null
                      ? AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: _engine,
                            canvas: VideoCanvas(uid: _remoteUid),
                            connection: RtcConnection(channelId: AgoraConfig.channel),
                          ),
                        )
                      : Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(
                        _isJoined ? 'Waiting for remote user…' : 'Joining channel…',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
            ),

            // Local view PIP top-right
            Positioned(
              top: 16,
              right: 16,
              width: 120,
              height: 180,
              child: !_engineReady
                  ? const SizedBox.shrink()
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black,
                  child: _videoOff && !_isScreenSharing
                      ? const Center(child: Icon(Icons.videocam_off, color: Colors.white70))
                      : AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _roundButton(
                    icon: _micMuted ? Icons.mic_off : Icons.mic,
                    color: _micMuted ? Colors.orange : Colors.white,
                    onPressed: _toggleMic,
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: _videoOff ? Icons.videocam_off : Icons.videocam,
                    color: _videoOff ? Colors.orange : Colors.white,
                    onPressed: _toggleVideo,
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
                    color: _isScreenSharing ? Colors.orange : Colors.white,
                    onPressed: _toggleScreenShare,
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: Icons.call_end,
                    bg: Colors.red,
                    color: Colors.white,
                    onPressed: _endCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color bg = const Color.fromARGB(255, 46, 46, 46),
    Color color = Colors.white,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Material(
        color: bg,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, color: color),
          ),
        ),
      ),
    );
  }
}