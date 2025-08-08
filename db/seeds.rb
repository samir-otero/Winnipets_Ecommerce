# Create Provinces with tax rates (2023 rates)
provinces_data = [
  { name: "Alberta", abbreviation: "AB", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "British Columbia", abbreviation: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "Manitoba", abbreviation: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "New Brunswick", abbreviation: "NB", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", abbreviation: "NL", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Northwest Territories", abbreviation: "NT", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Nova Scotia", abbreviation: "NS", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Nunavut", abbreviation: "NU", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Ontario", abbreviation: "ON", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.13 },
  { name: "Prince Edward Island", abbreviation: "PE", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Quebec", abbreviation: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.0 },
  { name: "Saskatchewan", abbreviation: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.0 },
  { name: "Yukon", abbreviation: "YT", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by(abbreviation: province_data[:abbreviation]) do |province|
    province.name = province_data[:name]
    province.gst_rate = province_data[:gst_rate]
    province.pst_rate = province_data[:pst_rate]
    province.hst_rate = province_data[:hst_rate]
  end
end

# Create Categories
categories = [
  { name: "Winter Gear", description: "Coats, boots, and heating products for Canadian winters" },
  { name: "Natural Treats", description: "Locally sourced treats made with prairie-grown ingredients" },
  { name: "Grooming Supplies", description: "Professional shampoos, brushes, and grooming tools" },
  { name: "Farm Animal Care", description: "Feed supplements and health products for rural customers" },
  { name: "Toys & Entertainment", description: "Interactive toys and entertainment for pets of all sizes" },
  { name: "Health & Wellness", description: "Vitamins, supplements, and health products for optimal pet care" },
  { name: "Bedding & Comfort", description: "Comfortable beds, blankets, and cozy accessories" },
  { name: "Training Supplies", description: "Training tools, leashes, collars, and behavior aids" }
]

categories.each do |cat_data|
  Category.find_or_create_by(name: cat_data[:name]) do |category|
    category.description = cat_data[:description]
  end
end

# Create Admin User
AdminUser.find_or_create_by(email: "admin@winnipets.com") do |admin|
  admin.first_name = "Admin"
  admin.last_name = "User"
  admin.password = "password123"
  admin.password_confirmation = "password123"
  admin.role = "admin"
end

# Create Pages
Page.find_or_create_by(slug: "about") do |page|
  page.title = "About Winnipets"
  page.content = "Winnipets has been serving Manitoba's pet community for 8 years..."
end

Page.find_or_create_by(slug: "contact") do |page|
  page.title = "Contact Us"
  page.content = "Visit our store on Portage Avenue or contact us..."
end

puts "Seeded #{Province.count} provinces"
puts "Seeded #{Category.count} categories"
puts "Created admin user: #{AdminUser.first&.email}"
puts "Created #{Page.count} pages"

# Create comprehensive product catalog
if Category.any?
  # Get category references
  winter_gear = Category.find_by(name: "Winter Gear")
  natural_treats = Category.find_by(name: "Natural Treats")
  grooming = Category.find_by(name: "Grooming Supplies")
  farm_care = Category.find_by(name: "Farm Animal Care")
  toys = Category.find_by(name: "Toys & Entertainment")
  health = Category.find_by(name: "Health & Wellness")
  bedding = Category.find_by(name: "Bedding & Comfort")
  training = Category.find_by(name: "Training Supplies")

  sample_products = [
    # Winter Gear Products (4 products)
    {
      name: "Manitoba Winter Dog Coat",
      description: "Heavy-duty winter coat designed for Manitoba's harsh winters. Features waterproof outer shell and thermal insulation.",
      price: 89.99,
      sale_price: 69.99,
      stock_quantity: 25,
      sku: "WC-MB-001",
      weight: 0.8,
      category: winter_gear
    },
    {
      name: "Heated Water Bowl",
      description: "Prevents water from freezing in cold Manitoba winters. Safe for outdoor use with chew-resistant cord.",
      price: 149.99,
      stock_quantity: 8,
      sku: "WG-BOWL-001",
      weight: 2.5,
      category: winter_gear
    },
    {
      name: "Arctic Paw Protector Boots",
      description: "Durable winter boots with non-slip soles and reflective straps. Perfect for icy Winnipeg sidewalks.",
      price: 45.99,
      sale_price: 39.99,
      stock_quantity: 32,
      sku: "WG-BOOTS-001",
      weight: 0.4,
      category: winter_gear
    },
    {
      name: "Insulated Outdoor Kennel Pad",
      description: "Thick, insulated pad for outdoor kennels. Waterproof and easy to clean.",
      price: 79.99,
      stock_quantity: 15,
      sku: "WG-PAD-001",
      weight: 1.8,
      category: winter_gear
    },

    # Natural Treats Products (4 products)
    {
      name: "Prairie Beef Treats",
      description: "All-natural beef treats made from grass-fed Manitoba cattle. No preservatives or artificial ingredients.",
      price: 24.99,
      stock_quantity: 50,
      sku: "PT-BEEF-001",
      weight: 0.5,
      category: natural_treats
    },
    {
      name: "Saskatchewan Grain-Free Biscuits",
      description: "Wholesome biscuits made with Saskatchewan-grown oats and local honey. Perfect for training rewards.",
      price: 18.99,
      stock_quantity: 75,
      sku: "NT-BISCUIT-001",
      weight: 0.6,
      category: natural_treats
    },
    {
      name: "Wild Manitoba Blueberry Chews",
      description: "Soft chews packed with antioxidant-rich Manitoba blueberries. Great for senior dogs.",
      price: 22.50,
      sale_price: 19.99,
      stock_quantity: 40,
      sku: "NT-BLUE-001",
      weight: 0.3,
      category: natural_treats
    },
    {
      name: "Prairie Chicken & Sweet Potato Strips",
      description: "Dehydrated chicken and sweet potato strips. Single ingredient, perfect for sensitive stomachs.",
      price: 28.99,
      stock_quantity: 35,
      sku: "NT-CHICK-001",
      weight: 0.4,
      category: natural_treats
    },

    # Grooming Supplies Products (3 products)
    {
      name: "Professional Grooming Brush Set",
      description: "Complete set of professional grooming brushes suitable for all coat types. Includes slicker brush, pin brush, and undercoat rake.",
      price: 79.99,
      stock_quantity: 15,
      sku: "GS-BRUSH-001",
      weight: 1.2,
      category: grooming
    },
    {
      name: "Oatmeal & Honey Shampoo",
      description: "Gentle, moisturizing shampoo with natural oatmeal and Manitoba honey. Perfect for sensitive skin.",
      price: 32.99,
      stock_quantity: 28,
      sku: "GS-SHAMP-001",
      weight: 1.0,
      category: grooming
    },
    {
      name: "Professional Nail Trimmer Kit",
      description: "Stainless steel nail trimmers with safety guard and LED light. Includes nail file and quick-stop powder.",
      price: 45.99,
      sale_price: 39.99,
      stock_quantity: 20,
      sku: "GS-NAIL-001",
      weight: 0.7,
      category: grooming
    },

    # Farm Animal Care Products (3 products)
    {
      name: "Livestock Feed Supplement",
      description: "Vitamin and mineral supplement for cattle and horses. Formulated for prairie conditions.",
      price: 45.99,
      stock_quantity: 30,
      sku: "FC-SUPP-001",
      weight: 5.0,
      category: farm_care
    },
    {
      name: "Poultry Calcium & Grit Blend",
      description: "Essential calcium and grit supplement for laying hens. Promotes strong eggshells and healthy digestion.",
      price: 19.99,
      stock_quantity: 45,
      sku: "FC-CALC-001",
      weight: 2.5,
      category: farm_care
    },
    {
      name: "Large Animal First Aid Kit",
      description: "Comprehensive first aid kit for horses, cattle, and other large animals. Weather-resistant case included.",
      price: 89.99,
      stock_quantity: 12,
      sku: "FC-AID-001",
      weight: 3.2,
      category: farm_care
    },

    # Toys & Entertainment Products (3 products)
    {
      name: "Interactive Puzzle Feeder",
      description: "Mental stimulation puzzle that makes mealtime fun. Adjustable difficulty levels for dogs of all intelligence.",
      price: 34.99,
      stock_quantity: 22,
      sku: "TOY-PUZZLE-001",
      weight: 0.9,
      category: toys
    },
    {
      name: "Rope & Rubber Tug Toy",
      description: "Durable tug toy combining natural cotton rope with tough rubber. Perfect for interactive play.",
      price: 16.99,
      sale_price: 12.99,
      stock_quantity: 60,
      sku: "TOY-TUG-001",
      weight: 0.5,
      category: toys
    },
    {
      name: "Catnip-Filled Mouse Set",
      description: "Set of 6 realistic mice filled with premium Canadian catnip. Hours of hunting fun for indoor cats.",
      price: 14.99,
      stock_quantity: 38,
      sku: "TOY-MICE-001",
      weight: 0.2,
      category: toys
    },

    # Health & Wellness Products (3 products)
    {
      name: "Joint Support Chewable Tablets",
      description: "Glucosamine and chondroitin supplements for joint health. Beef-flavored chewables dogs love.",
      price: 52.99,
      stock_quantity: 25,
      sku: "HW-JOINT-001",
      weight: 0.8,
      category: health
    },
    {
      name: "Omega-3 Fish Oil Capsules",
      description: "Pure Canadian fish oil rich in omega-3 fatty acids. Supports coat health and reduces inflammation.",
      price: 38.99,
      sale_price: 34.99,
      stock_quantity: 42,
      sku: "HW-OMEGA-001",
      weight: 0.6,
      category: health
    },
    {
      name: "Probiotic Digestive Support",
      description: "Multi-strain probiotic powder to support digestive health. Unflavored powder mixes easily with food.",
      price: 44.99,
      stock_quantity: 18,
      sku: "HW-PROB-001",
      weight: 0.4,
      category: health
    },

    # Bedding & Comfort Products (3 products)
    {
      name: "Memory Foam Orthopedic Bed",
      description: "Premium memory foam bed with removable, washable cover. Perfect for senior dogs and large breeds.",
      price: 129.99,
      sale_price: 99.99,
      stock_quantity: 14,
      sku: "BED-ORTHO-001",
      weight: 4.5,
      category: bedding
    },
    {
      name: "Heated Cat Bed",
      description: "Self-warming cat bed that reflects body heat. No electricity required, machine washable.",
      price: 39.99,
      stock_quantity: 26,
      sku: "BED-CAT-001",
      weight: 1.1,
      category: bedding
    },
    {
      name: "Waterproof Crate Mat",
      description: "Durable, waterproof mat perfect for crates and kennels. Non-slip bottom with raised edges.",
      price: 29.99,
      stock_quantity: 33,
      sku: "BED-MAT-001",
      weight: 1.8,
      category: bedding
    },

    # Training Supplies Products (2 products)
    {
      name: "Professional Training Leash Set",
      description: "6-foot training leash with padded handle and matching collar. Reflective stitching for night visibility.",
      price: 42.99,
      stock_quantity: 28,
      sku: "TRAIN-LEASH-001",
      weight: 0.6,
      category: training
    },
    {
      name: "Clicker Training Starter Kit",
      description: "Complete clicker training kit with instruction booklet, clicker, and treat pouch. Perfect for beginners.",
      price: 24.99,
      sale_price: 19.99,
      stock_quantity: 45,
      sku: "TRAIN-CLICK-001",
      weight: 0.3,
      category: training
    }
  ]

  sample_products.each do |product_data|
    Product.find_or_create_by(sku: product_data[:sku]) do |product|
      product.name = product_data[:name]
      product.description = product_data[:description]
      product.price = product_data[:price]
      product.sale_price = product_data[:sale_price]
      product.stock_quantity = product_data[:stock_quantity]
      product.weight = product_data[:weight]
      product.category = product_data[:category]
      product.is_active = true
    end
  end

  puts "Created #{Product.count} products across #{Category.count} categories"

  # Print breakdown by category
  categories.each do |cat_data|
    category = Category.find_by(name: cat_data[:name])
    puts "  - #{category.name}: #{category.products.count} products" if category
  end
end