class OnbordingContent {
  String image;
  String title;
  String discription;

  OnbordingContent({required this.image, required this.title, required this.discription});
}

List<OnbordingContent> contents = [
  OnbordingContent(
      title: 'Get the best deals',
      image: 'assets/best_deals.png',
      discription: "Post an offer or explore multiple offers with great rates from people just like you and negotiate with them."
  ),
  OnbordingContent(
      title: 'More value for your money',
      image: 'assets/more_value_money.png',
      discription: "Send money for free or at an extremely affordable fee with no exchange rate markups or hidden fees."
  ),
  OnbordingContent(
      title: 'Enjoy peace of mind',
      image: 'assets/peace_of_mind.png',
      discription: "Feel safe transacting on our highly-secure platform with vetted members plus we serve as an escrow to keep you safe."
  ),
];