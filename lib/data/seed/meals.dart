import '../models/meal.dart';

const List<Meal> seedMeals = [
  // BREAKFAST
  Meal(
    id: 'meal_b1',
    name: 'Classic Oatmeal with Blueberries & Whey',
    calories: 420,
    category: 'Breakfast',
    description:
        'Warm rolled oats infused with vanilla whey protein, cinnamon, and fresh organic blueberries.',
    ingredients: [
      '60g rolled oats',
      '1 scoop vanilla whey protein isolate',
      '150ml unsweetened almond milk',
      '50g fresh blueberries',
      '1 tsp chia seeds',
      'Dash of Ceylon cinnamon',
    ],
  ),
  Meal(
    id: 'meal_b2',
    name: 'Avocado & Poached Eggs on Sourdough',
    calories: 480,
    category: 'Breakfast',
    description:
        'Toasted artisan sourdough topped with mashed ripe avocado, chili flakes, and two free-range poached eggs.',
    ingredients: [
      '2 slices artisan sourdough bread',
      '2 large eggs',
      '1/2 medium avocado',
      'Pinch of red pepper flakes',
      'Sea salt & black pepper',
      'Squeeze of fresh lemon',
    ],
  ),
  Meal(
    id: 'meal_b3',
    name: 'Greek Yogurt Superfood Parfait',
    calories: 350,
    category: 'Breakfast',
    description:
        'Creamy high-protein Greek yogurt layered with raw honey, crunchy almond granola, and strawberries.',
    ingredients: [
      '200g 0% plain Greek yogurt',
      '30g low-sugar granola',
      '1 tbsp raw honey',
      '60g sliced fresh strawberries',
      '1 tbsp hemp hearts',
    ],
  ),
  Meal(
    id: 'meal_b4',
    name: 'Scrambled Eggs with Spinach & Smoked Salmon',
    calories: 390,
    category: 'Breakfast',
    description:
        'Fluffy whole egg scramble sautéed with baby spinach and served with Scottish smoked salmon slices.',
    ingredients: [
      '3 large free-range eggs',
      '60g smoked salmon',
      '1 cup baby spinach',
      '1 tsp extra virgin olive oil',
      'Fresh dill & cracked pepper',
    ],
  ),
  Meal(
    id: 'meal_b5',
    name: 'Banana Peanut Butter Protein Pancakes',
    calories: 540,
    category: 'Breakfast',
    description:
        'Fluffy 3-ingredient oat and egg protein pancakes drizzled with natural peanut butter and maple syrup.',
    ingredients: [
      '1 ripe banana',
      '2 eggs',
      '40g blended oat flour',
      '1 scoop vanilla protein powder',
      '1 tbsp natural creamy peanut butter',
      '1 tbsp pure maple syrup',
    ],
  ),
  Meal(
    id: 'meal_b6',
    name: 'Mediterranean Veggie Omelet',
    calories: 340,
    category: 'Breakfast',
    description:
        'Three-egg skillet omelet loaded with cherry tomatoes, Kalamata olives, bell peppers, and crumbled feta cheese.',
    ingredients: [
      '3 eggs',
      '30g crumbled feta cheese',
      '5 cherry tomatoes (halved)',
      '1/4 cup diced bell pepper',
      '4 pitted Kalamata olives',
      '1 tsp olive oil',
    ],
  ),

  // LUNCH
  Meal(
    id: 'meal_l1',
    name: 'Grilled Lemon Herb Chicken Bowl',
    calories: 560,
    category: 'Lunch',
    description:
        'Marinated chicken breast served over fluffy quinoa with roasted broccoli and tahini drizzle.',
    ingredients: [
      '180g lean chicken breast',
      '120g cooked quinoa',
      '150g roasted broccoli florets',
      '1 tbsp tahini dressing',
      'Fresh lemon juice, oregano, garlic',
    ],
  ),
  Meal(
    id: 'meal_l2',
    name: 'Wild Salmon & Sweet Potato Mash',
    calories: 620,
    category: 'Lunch',
    description:
        'Crispy pan-seared wild salmon fillet served alongside mashed sweet potato and steamed asparagus.',
    ingredients: [
      '170g wild-caught salmon fillet',
      '200g steamed sweet potato',
      '8 asparagus spears',
      '1 tsp grass-fed butter',
      'Sea salt and cracked black pepper',
    ],
  ),
  Meal(
    id: 'meal_l3',
    name: 'Turkey Quinoa Burrito Bowl',
    calories: 590,
    category: 'Lunch',
    description:
        'Lean ground turkey with Mexican spices, black beans, sweet corn, salsa fresca, and diced avocado.',
    ingredients: [
      '150g extra-lean ground turkey (93/7)',
      '100g cooked brown rice or quinoa',
      '50g black beans',
      '30g sweet corn',
      '3 tbsp fresh tomato pico de gallo',
      '1/4 diced avocado',
    ],
  ),
  Meal(
    id: 'meal_l4',
    name: 'Tuna Salad Crisp Wrap',
    calories: 440,
    category: 'Lunch',
    description:
        'Light Albacore tuna blended with Greek yogurt, Dijon mustard, and celery inside a whole-wheat tortilla.',
    ingredients: [
      '1 can (150g) solid white tuna in water',
      '1 large whole wheat tortilla',
      '2 tbsp Greek yogurt',
      '1 tsp Dijon mustard',
      '1 rib finely chopped celery',
      'Romaine lettuce leaves',
    ],
  ),
  Meal(
    id: 'meal_l5',
    name: 'Crispy Tofu & Edamame Soba Noodles',
    calories: 510,
    category: 'Lunch',
    description:
        'Golden pan-seared organic firm tofu tossed with buckwheat soba noodles, edamame, and sesame soy glaze.',
    ingredients: [
      '150g extra-firm organic tofu',
      '80g buckwheat soba noodles (dry weight)',
      '50g steamed edamame beans',
      '1 tbsp low-sodium tamari soy sauce',
      '1 tsp toasted sesame oil & seeds',
      'Green onions & cilantro',
    ],
  ),
  Meal(
    id: 'meal_l6',
    name: 'Cottage Cheese & Chickpea Power Salad',
    calories: 380,
    category: 'Lunch',
    description:
        'Refreshing chopped cucumber, cherry tomato, and spiced chickpeas paired with probiotic cottage cheese.',
    ingredients: [
      '180g low-fat cottage cheese',
      '80g rinsed canned chickpeas',
      '1 cup diced English cucumber',
      '1/2 cup cherry tomatoes',
      '1 tsp olive oil with red wine vinegar',
    ],
  ),

  // DINNER
  Meal(
    id: 'meal_d1',
    name: 'Grass-Fed Sirloin Steak with Roasted Asparagus',
    calories: 680,
    category: 'Dinner',
    description:
        'Tender cast-iron seared sirloin steak paired with rosemary roasted baby red potatoes and asparagus.',
    ingredients: [
      '200g lean sirloin steak',
      '150g roasted baby red potatoes',
      '10 spears grilled asparagus',
      '1 tsp garlic herb butter',
      'Coarse sea salt & black peppercorns',
    ],
  ),
  Meal(
    id: 'meal_d2',
    name: 'Baked Herb Cod with Brown Rice & Zucchini',
    calories: 490,
    category: 'Dinner',
    description:
        'Delicate Pacific cod baked in white wine and herbs, served over brown jasmine rice with sautéed zucchini.',
    ingredients: [
      '200g Pacific cod fillet',
      '130g cooked brown jasmine rice',
      '1 medium sliced zucchini',
      '1 tbsp olive oil',
      'Parsley, garlic powder, paprika',
    ],
  ),
  Meal(
    id: 'meal_d3',
    name: 'Hearty Beef & Bean Chili',
    calories: 640,
    category: 'Dinner',
    description:
        'Slow-simmered lean ground beef with kidney beans, crushed fire-roasted tomatoes, and cheddar topping.',
    ingredients: [
      '180g lean minced beef',
      '80g kidney beans',
      '150g crushed tomatoes',
      '20g shredded sharp cheddar',
      'Chili powder, cumin, smoked paprika',
    ],
  ),
  Meal(
    id: 'meal_d4',
    name: 'Chicken Breast Stir-Fry with Jasmine Rice',
    calories: 570,
    category: 'Dinner',
    description:
        'Tender chicken strips wok-fried with snap peas, carrots, bell peppers, ginger, and aromatic jasmine rice.',
    ingredients: [
      '180g diced chicken breast',
      '120g steamed jasmine rice',
      '1 cup mixed stir-fry vegetables (snap peas, bell peppers, carrots)',
      '1 tbsp garlic ginger stir-fry sauce',
      '1 tsp sesame oil',
    ],
  ),
  Meal(
    id: 'meal_d5',
    name: 'Massive Muscle Recovery Pasta',
    calories: 820,
    category: 'Dinner',
    description:
        'High-carb post-workout pasta with extra lean ground turkey, chunky marinara sauce, and parmesan.',
    ingredients: [
      '120g whole grain penne (dry weight)',
      '200g 93% lean ground turkey',
      '150g marinara pasta sauce',
      '25g grated parmesan cheese',
      'Fresh basil & garlic',
    ],
  ),
  Meal(
    id: 'meal_d6',
    name: 'Garlic Butter Jumbo Shrimp with Quinoa',
    calories: 460,
    category: 'Dinner',
    description:
        'Succulent wild jumbo shrimp pan-seared in clarified garlic butter over lemon-herb tri-color quinoa.',
    ingredients: [
      '180g peeled wild shrimp',
      '120g cooked tri-color quinoa',
      '1 cup sautéed spinach',
      '1 tbsp grass-fed garlic butter',
      'Squeeze of fresh lemon & red chili flakes',
    ],
  ),
  Meal(
    id: 'meal_d7',
    name: 'Plant-Based Lentil & Sweet Potato Curry',
    calories: 520,
    category: 'Dinner',
    description:
        'Comforting golden turmeric curry loaded with red lentils, sweet potato chunks, spinach, and coconut milk.',
    ingredients: [
      '70g dried red split lentils',
      '120g sweet potato cubes',
      '80ml light coconut milk',
      '1 cup baby spinach',
      'Garam masala, turmeric, ginger',
    ],
  ),

  // SNACK
  Meal(
    id: 'meal_s1',
    name: 'Apple Slices with Creamy Almond Butter',
    calories: 280,
    category: 'Snack',
    description:
        'Crisp Honeycrisp apple wedges paired with all-natural roasted almond butter and cinnamon.',
    ingredients: [
      '1 medium Honeycrisp apple',
      '2 tbsp raw almond butter',
      'Sprinkle of ground cinnamon',
    ],
  ),
  Meal(
    id: 'meal_s2',
    name: 'Whey Protein Shake with Cold Brew Coffee',
    calories: 190,
    category: 'Snack',
    description:
        'Energizing pre-workout shake made with rich chocolate whey isolate, cold brew concentrate, and ice.',
    ingredients: [
      '1 scoop chocolate whey isolate',
      '150ml cold brew coffee',
      '150ml unsweetened almond milk',
      'Ice cubes',
    ],
  ),
  Meal(
    id: 'meal_s3',
    name: 'Mixed Raw Nuts & Medjool Dates',
    calories: 320,
    category: 'Snack',
    description:
        'Wholesome nutrient-dense blend of California walnuts, almonds, and plump pitted Medjool dates.',
    ingredients: [
      '25g raw walnuts',
      '20g whole raw almonds',
      '2 pitted Medjool dates',
    ],
  ),
  Meal(
    id: 'meal_s4',
    name: 'Hard-Boiled Eggs with Guacamole Dip',
    calories: 260,
    category: 'Snack',
    description:
        'Two pasture-raised hard-boiled eggs cut in half and paired with single-serve fresh guacamole.',
    ingredients: [
      '2 large hard-boiled eggs',
      '60g fresh avocado guacamole',
      'Everything bagel seasoning',
    ],
  ),
  Meal(
    id: 'meal_s5',
    name: 'Rice Cakes with Peanut Butter & Banana Slices',
    calories: 290,
    category: 'Snack',
    description:
        'Two crunchy whole-grain brown rice cakes coated with natural peanut butter and thinly sliced banana.',
    ingredients: [
      '2 lightly salted brown rice cakes',
      '1.5 tbsp creamy peanut butter',
      '1/2 sliced banana',
      'Drizzle of raw honey',
    ],
  ),
  Meal(
    id: 'meal_s6',
    name: 'Protein Mug Cake with Dark Chocolate Chips',
    calories: 310,
    category: 'Snack',
    description:
        'Quick 60-second microwave protein cake made with chocolate casein, cocoa powder, and dark chocolate chips.',
    ingredients: [
      '1 scoop chocolate casein or whey protein',
      '1 tbsp unsweetened cacao powder',
      '1/4 tsp baking powder',
      '4 tbsp unsweetened oat milk',
      '10g 70% dark chocolate chips',
    ],
  ),
];

