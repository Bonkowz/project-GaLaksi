enum Interest {
  // Sports
  athletics(InterestCategory.sports, "Athletics"),
  badminton(InterestCategory.sports, "Badminton"),
  basketball(InterestCategory.sports, "Basketball"),
  bowling(InterestCategory.sports, "Bowling"),
  football(InterestCategory.sports, "Football"),
  gym(InterestCategory.sports, "Gym"),
  soccer(InterestCategory.sports, "Soccer"),
  tennis(InterestCategory.sports, "Tennis"),
  yoga(InterestCategory.sports, "Yoga"),
  volleyball(InterestCategory.sports, "Volleyball"),
  otherSports(InterestCategory.sports, "Other"),

  // Going Out
  bars(InterestCategory.goingOut, "Bars"),
  cafes(InterestCategory.goingOut, "Cafes"),
  concerts(InterestCategory.goingOut, "Concerts"),
  dragShows(InterestCategory.goingOut, "Drag Shows"),
  festivals(InterestCategory.goingOut, "Festivals"),
  karaoke(InterestCategory.goingOut, "Karaoke"),
  lgbtqNightlife(InterestCategory.goingOut, "LGBTQ+ Nightlife"),
  museumsAndGalleries(InterestCategory.goingOut, "Museums and Galleries"),
  nightClubs(InterestCategory.goingOut, "Night Clubs"),
  standup(InterestCategory.goingOut, "Standup"),
  theatre(InterestCategory.goingOut, "Theatre"),
  otherGoingOut(InterestCategory.goingOut, "Other"),

  // Music
  blues(InterestCategory.music, "Blues"),
  classical(InterestCategory.music, "Classical"),
  country(InterestCategory.music, "Country"),
  edm(InterestCategory.music, "EDM"),
  electronic(InterestCategory.music, "Electronic"),
  folkAndAcoustic(InterestCategory.music, "Folk & Acoustic"),
  funk(InterestCategory.music, "Funk"),
  hipHop(InterestCategory.music, "Hip-Hop"),
  indie(InterestCategory.music, "Indie"),
  jazz(InterestCategory.music, "Jazz"),
  kpop(InterestCategory.music, "K-Pop"),
  metal(InterestCategory.music, "Metal"),
  pop(InterestCategory.music, "Pop"),
  punk(InterestCategory.music, "Punk"),
  rnb(InterestCategory.music, "R&B"),
  rap(InterestCategory.music, "Rap"),
  reggae(InterestCategory.music, "Reggae"),
  rock(InterestCategory.music, "Rock"),
  soul(InterestCategory.music, "Soul"),
  techno(InterestCategory.music, "Techno"),
  otherMusic(InterestCategory.music, "Other"),

  // Food and Drink
  beer(InterestCategory.foodAndDrink, "Beer"),
  bobaTea(InterestCategory.foodAndDrink, "Boba Tea"),
  coffee(InterestCategory.foodAndDrink, "Coffee"),
  cocktails(InterestCategory.foodAndDrink, "Cocktails"),
  gin(InterestCategory.foodAndDrink, "Gin"),
  foodie(InterestCategory.foodAndDrink, "Foodie"),
  pizza(InterestCategory.foodAndDrink, "Pizza"),
  plantBased(InterestCategory.foodAndDrink, "Plant-based"),
  sushi(InterestCategory.foodAndDrink, "Sushi"),
  sweetTooth(InterestCategory.foodAndDrink, "Sweet Tooth"),
  takeout(InterestCategory.foodAndDrink, "Takeout"),
  tea(InterestCategory.foodAndDrink, "Tea"),
  vegan(InterestCategory.foodAndDrink, "Vegan"),
  vegetarian(InterestCategory.foodAndDrink, "Vegetarian"),
  whisky(InterestCategory.foodAndDrink, "Whisky"),
  wine(InterestCategory.foodAndDrink, "Wine"),
  otherFoodAndDrink(InterestCategory.foodAndDrink, "Other"),

  // Pets
  birds(InterestCategory.pets, "Birds"),
  cats(InterestCategory.pets, "Cats"),
  dogs(InterestCategory.pets, "Dogs"),
  fish(InterestCategory.pets, "Fish"),
  lizards(InterestCategory.pets, "Lizards"),
  rabbits(InterestCategory.pets, "Rabbits"),
  snakes(InterestCategory.pets, "Snakes"),
  turtles(InterestCategory.pets, "Turtles"),
  otherPets(InterestCategory.pets, "Other");

  const Interest(this.category, this.title);
  final InterestCategory category;
  final String title;
}

enum InterestCategory {
  sports("Sports"),
  music("Music"),
  goingOut("Going Out"),
  foodAndDrink("Food and Drink"),
  pets("Pets");

  const InterestCategory(this.title);
  final String title;
}
