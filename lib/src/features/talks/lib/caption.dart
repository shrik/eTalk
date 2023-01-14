
enum CaptionEnum{
  OriginalText,
  FiftyPercentPrompt,
  TwentyFivePercentPrompt,
  ChinesePrompt,
  HideOriginalText,
}

const Map<CaptionEnum, String> captionOptions = {
  CaptionEnum.OriginalText: "显示原文",
  CaptionEnum.FiftyPercentPrompt: "50%提示",
  CaptionEnum.TwentyFivePercentPrompt: "25%提示",
  CaptionEnum.ChinesePrompt: "中文提示",
  CaptionEnum.HideOriginalText: "隐藏原文",
};