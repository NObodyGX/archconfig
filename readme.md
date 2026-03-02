# readme

my simple arch linux config script, include:

1. install software
2. config software for normal

## 音量

```bash
# 耳机音量增加5%
pactl set-sink-volume @DEFAULT_SINK@ +5%

# 麦克风音量增加5%
pactl set-source-volume @DEFAULT_SOURCE@ +5%
```
