class SidebarStep {
  final String title;
  final int? number; // Only parent/group steps have numbers
  final List<SidebarStep>? children;

  SidebarStep({required this.title, this.number, this.children});
}
