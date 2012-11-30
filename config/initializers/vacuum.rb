VACUUM = Vacuum.new 'FR'
VACUUM.configure(
  key: ENV['AMAZON_PRODUCT_KEY'],
  secret: ENV['AMAZON_PRODUCT_SECRET'],
  tag: ENV['AMAZON_PRODUCT_TAG']
)
