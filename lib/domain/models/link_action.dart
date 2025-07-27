sealed class LinkAction {
  const LinkAction();
}

class LaunchBrowser extends LinkAction {
  final String url;
  const LaunchBrowser(this.url);
}

class OpenFileAction extends LinkAction {
  final String path;
  const OpenFileAction(this.path);
}

class ShowError extends LinkAction {
  final String message;
  const ShowError(this.message);
}