import ballerina/http;

type Movie record {
    int id;
    string title;
    string director;
    string genre;
    int releaseYear;
    float rating;
    int duration; // in minutes
    string description;
};

map<Movie> movies = {};

service http:Service /movie\-store on new http:Listener(8083) {

    // GET /movies - Get all movies
    resource function get movies() returns Movie[] {
        return movies.toArray();
    }

    // GET /movies/{id} - Get a specific movie by ID
    resource function get movies/[int id]() returns Movie|http:NotFound {
        Movie? movie = movies[id.toString()];
        if movie is Movie {
            return movie;
        }
        return http:NOT_FOUND;
    }

    // GET /movies/search?q={query} - Search movies by title or director
    resource function get movies/search(string q) returns Movie[] {
        Movie[] searchResults = [];
        string searchQuery = q.toLowerAscii();

        foreach Movie movie in movies.toArray() {
            if movie.title.toLowerAscii().includes(searchQuery) ||
                movie.director.toLowerAscii().includes(searchQuery) {
                searchResults.push(movie);
            }
        }
        return searchResults;
    }

    // POST /movies - Create a new movie
    resource function post movies(@http:Payload Movie newMovie) returns http:Created|http:BadRequest {
        // Validate required fields
        if newMovie.title.trim() == "" || newMovie.director.trim() == "" {
            return http:BAD_REQUEST;
        }

        // Validate rating range (0.0 to 10.0)
        if newMovie.rating < 0.0 || newMovie.rating > 10.0 {
            return http:BAD_REQUEST;
        }

        // Validate release year (reasonable range)
        if newMovie.releaseYear < 1900 || newMovie.releaseYear > 2030 {
            return http:BAD_REQUEST;
        }

        int newId = movies.length() + 1;
        // Assign ID and store the movie
        Movie movie = {
            id: newId,
            title: newMovie.title,
            director: newMovie.director,
            genre: newMovie.genre,
            releaseYear: newMovie.releaseYear,
            rating: newMovie.rating,
            duration: newMovie.duration,
            description: newMovie.description
        };

        movies[newId.toString()] = movie;

        return http:CREATED;
    }

    // PUT /movies/{id} - Update an existing movie
    resource function put movies/[int id](@http:Payload Movie updatedMovie) returns Movie|http:NotFound|http:BadRequest {
        if !movies.hasKey(id.toString()) {
            return http:NOT_FOUND;
        }

        // Validate required fields
        if updatedMovie.title.trim() == "" || updatedMovie.director.trim() == "" {
            return http:BAD_REQUEST;
        }

        // Validate rating range
        if updatedMovie.rating < 0.0 || updatedMovie.rating > 10.0 {
            return http:BAD_REQUEST;
        }

        // Validate release year
        if updatedMovie.releaseYear < 1900 || updatedMovie.releaseYear > 2030 {
            return http:BAD_REQUEST;
        }

        Movie movie = {
            id: id,
            title: updatedMovie.title,
            director: updatedMovie.director,
            genre: updatedMovie.genre,
            releaseYear: updatedMovie.releaseYear,
            rating: updatedMovie.rating,
            duration: updatedMovie.duration,
            description: updatedMovie.description
        };

        movies[id.toString()] = movie;
        return movie;
    }

    // PATCH /movies/{id}/rating - Update only the rating of a movie
    resource function patch movies/[int id]/rating(@http:Payload record {float rating;} ratingUpdate) returns Movie|http:NotFound|http:BadRequest {
        if !movies.hasKey(id.toString()) {
            return http:NOT_FOUND;
        }

        if ratingUpdate.rating < 0.0 || ratingUpdate.rating > 10.0 {
            return http:BAD_REQUEST;
        }

        Movie existingMovie = <Movie>movies[id.toString()];
        Movie updatedMovie = existingMovie;
        updatedMovie.rating = ratingUpdate.rating;
        movies[id.toString()] = updatedMovie;
        return updatedMovie;
    }

    // DELETE /movies/{id} - Delete a movie
    resource function delete movies/[int id]() returns http:NoContent|http:NotFound {
        if !movies.hasKey(id.toString()) {
            return http:NOT_FOUND;
        }

        _ = movies.remove(id.toString());
        return http:NO_CONTENT;
    }

}
