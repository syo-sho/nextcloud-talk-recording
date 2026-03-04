# Nextcloud Talk Recording (Standalone)


本项目是 [Nextcloud Talk Recording](https://github.com/nextcloud/nextcloud-talk-recording) ，代码复制自 [Nextcloud AIO (All-in-One)]

### 主要改进

* 原生 IPv6 ：修改 __main__.py，现在可以正常监听 [::] 地址。
* 默认监听Ipv4和Ipv6
* 中文乱码修复：内置 font-noto-cjk 和 ttf-dejavu 字体，确保 Nextcloud Talk 会议中的中文聊天记录和用户名称在录制视频中正常显示。
