$(document).on "ready page:load", ->
  searchInput = $(".typeahead")

  if searchInput.length > 0
    searchInput.typeahead(
      highlighter: (item) ->
        "<div class='typeahead-item'>#{item}</div>"
    ).on("keyup", (ev) ->
      ev.stopPropagation()
      ev.preventDefault()

      #filter out up/down, tab, enter, and escape keys
      if $.inArray(ev.keyCode, [40, 38, 9, 13, 27]) is -1
        self = $(this)

        #set typeahead source to empty
        self.data("typeahead").source = []

        #active used so we aren't triggering duplicate keyup events
        if not self.data("active") and self.val().length > 0
          self.data "active", true

          #Do data request. Insert your own API logic here.
          $.ajax
            url: "/api/v1/cities/autocomplete"
            type: 'POST'
            dataType: 'json'
            crossDomain: true
            data:
              city: $(@).val()
            success: (data) ->
              console.log data
              #set this to true when your callback executes
              self.data "active", true

              #Filter out your own parameters. Populate them into an array, since this is what typeahead's source requires
              arr = []
              i = data.cities.length
              arr[i] = data.cities[i]  while i--

              #set your results into the typehead's source 
              self.data("typeahead").source = arr

              #trigger keyup on the typeahead to make it search
              self.trigger "keyup"

              #All done, set to false to prepare for the next remote query.
              self.data "active", false
    )
