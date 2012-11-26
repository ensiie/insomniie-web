$(document).on "ready page:load", ->

  # Activate twitter bootstrap dropdown
  $('.dropdown-toggle').dropdown()

  # Activate twitter bootstrap carousel
  $('.carousel').carousel(
    interval: 5000
  )


$(window).load ->

  # Masonry
  $('.masonry').masonry()
