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
  bool _joining = false;
  bool _remoteVideoOff = false;

  @override
  void initState() {
    super.initState();
    // Delay engine creation until user taps Join
  }

  Future<void> _prepareAndJoin() async {
    if (_joining || _isJoined) return;
    setState(() {
      _joining = true;
    });

    await [Permission.camera, Permission.microphone].request();

    // Create engine synchronously right before initialization
    _engine = createAgoraRtcEngine();
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
          _remoteVideoOff = false;
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        setState(() {
          _remoteUid = null;
          _remoteVideoOff = false;
        });
      },
      onRemoteVideoStateChanged: (
        RtcConnection connection,
        int remoteUid,
        RemoteVideoState state,
        RemoteVideoStateReason reason,
        int elapsed,
      ) {
        if (remoteUid == _remoteUid) {
          final bool isOff = state == RemoteVideoState.remoteVideoStateStopped ||
              state == RemoteVideoState.remoteVideoStateFrozen;
          if (mounted) {
            setState(() {
              _remoteVideoOff = isOff;
            });
          }
        }
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
    if (mounted) {
      setState(() {
        _joining = false;
      });
    }
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
    if (_engineReady) {
      await _engine.leaveChannel();
      await _engine.stopPreview();
      await _engine.release();
    }
    setState(() {
      _isJoined = false;
      _remoteUid = null;
      _engineReady = false;
      _videoOff = false;
      _micMuted = false;
      _isScreenSharing = false;
    });
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    if (_engineReady) {
      _engine.stopPreview();
      _engine.release();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Pre-join screen with channel and link and a Join button
            if (!_engineReady && !_isJoined) Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Channel',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AgoraConfig.channel,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Link',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      'https://join.example.com/${AgoraConfig.channel}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    _joining
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _prepareAndJoin,
                            icon: const Icon(Icons.video_call),
                            label: const Text('Join Channel'),
                          ),
                  ],
                ),
              ),
            ),
            // Remote view full screen
            Positioned.fill(
              child: !_engineReady
                  ? const SizedBox.shrink()
                  : _remoteUid != null && !_remoteVideoOff
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _remoteUid != null ? Icons.videocam_off : Icons.person,
                                size: 64,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _remoteUid != null
                                    ? 'Remote camera disabled'
                                    : (_isJoined ? 'Waiting for remote user…' : 'Joining channel…'),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
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
            if (_engineReady)
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
                    onPressed: _engineReady ? _toggleMic : () {},
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: _videoOff ? Icons.videocam_off : Icons.videocam,
                    color: _videoOff ? Colors.orange : Colors.white,
                    onPressed: _engineReady ? _toggleVideo : () {},
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
                    color: _isScreenSharing ? Colors.orange : Colors.white,
                    onPressed: _engineReady ? _toggleScreenShare : () {},
                  ),
                  const SizedBox(width: 12),
                  _roundButton(
                    icon: Icons.call_end,
                    bg: Colors.red,
                    color: Colors.white,
                    onPressed: _engineReady ? _endCall : () {},
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