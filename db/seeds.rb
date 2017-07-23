# Users
10.times do
  email = FFaker::Internet.email
  password = FFaker::Internet.password
  User.create!({ email: email, password: password, password_confirmation: password })
end

# Products
users = User.order(:created_at).take(5)
20.times do
  title = FFaker::Product.product_name
  price = Kernel.rand(10000) / 100.0
  published = false
  users.each { |user| user.products.create!(title: title, price: price, published: published) }
end

20.times do
  total = Kernel.rand(10000) / 100.0
  users.each { |user| user.orders.create!(total: total) }
end

