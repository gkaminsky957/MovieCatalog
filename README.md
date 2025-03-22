**General Information:**

This application is simpe movie catalog application that allows the user to search movies by specifying movie title and type. It consists of two screens:
- Landing screes allows the user to enter moovie title and select the movie type. Movie title is required field. Pressing `submit` buttin transitions to the `Search Result` screen.
- Search Result screen makes a netwotk call to fech movies matching the user search preference. It displays the list of movies including the movie title, the  year movie was mad and movie poster image.

Appliction was written using MVVM architecture design. It uses open OMDb API (open moview database API) for fetching movies. It uses dependecy injection for injecting dependecies so unit testing can be done easily.
