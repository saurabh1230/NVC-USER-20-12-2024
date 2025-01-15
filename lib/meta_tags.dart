import 'dart:html' as html;

void updateMetaTags(String title, String description) {
  // Update title tag
  html.document.title = title;

  // Update meta description
  final metaDescriptionTag = html.document.querySelector("meta[name='description']");
  if (metaDescriptionTag != null) {
    metaDescriptionTag.setAttribute("content", description);
  } else {
    final metaTag = html.MetaElement()
      ..name = 'description'
      ..content = description;
    html.document.head?.append(metaTag);
  }
}


