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
  { name: "Farm Animal Care", description: "Feed supplements and health products for rural customers" }
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

# Create sample products
if Category.any?
  winter_gear = Category.find_by(name: "Winter Gear")
  natural_treats = Category.find_by(name: "Natural Treats")
  grooming = Category.find_by(name: "Grooming Supplies")
  farm_care = Category.find_by(name: "Farm Animal Care")

  sample_products = [
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
      name: "Prairie Beef Treats",
      description: "All-natural beef treats made from grass-fed Manitoba cattle. No preservatives or artificial ingredients.",
      price: 24.99,
      stock_quantity: 50,
      sku: "PT-BEEF-001",
      weight: 0.5,
      category: natural_treats
    },
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
      name: "Heated Water Bowl",
      description: "Prevents water from freezing in cold Manitoba winters. Safe for outdoor use with chew-resistant cord.",
      price: 149.99,
      stock_quantity: 8,
      sku: "WG-BOWL-001",
      weight: 2.5,
      category: winter_gear
    },
    {
      name: "Livestock Feed Supplement",
      description: "Vitamin and mineral supplement for cattle and horses. Formulated for prairie conditions.",
      price: 45.99,
      stock_quantity: 30,
      sku: "FC-SUPP-001",
      weight: 5.0,
      category: farm_care
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

  puts "Created #{Product.count} products"
end