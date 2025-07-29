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