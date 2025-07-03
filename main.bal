import ballerina/http;

type Book record {
    int id;
    string title;
    string author;
    string isbn;
    decimal price;
    string category;
};

map<Book> books = {};

service http:Service /book\-store on new http:Listener(8082) {

    // GET /books - Get all books
    resource function get books() returns Book[] {
        return books.toArray();
    }

    // GET /books/{id} - Get a specific book by ID
    resource function get books/[int id]() returns Book|http:NotFound {
        Book? book = books[id.toString()];
        if book is Book {
            return book;
        }
        return http:NOT_FOUND;
    }

    // POST /books - Create a new book
    resource function post books(@http:Payload Book newBook) returns http:Created|http:BadRequest {
        // Validate required fields
        if newBook.title.trim() == "" || newBook.author.trim() == "" {
            return http:BAD_REQUEST;
        }
        int newId = books.length() + 1;
        // Assign ID and store the book
        Book book = {
            id: newId,
            title: newBook.title,
            author: newBook.author,
            isbn: newBook.isbn,
            price: newBook.price,
            category: newBook.category
        };

        books[newId.toString()] = book;

        return http:CREATED;
    }

    // PUT /books/{id} - Update an existing book
    resource function put books/[int id](@http:Payload Book updatedBook) returns Book|http:NotFound|http:BadRequest {
        if !books.hasKey(id.toString()) {
            return http:NOT_FOUND;
        }

        // Validate required fields
        if updatedBook.title.trim() == "" || updatedBook.author.trim() == "" {
            return http:BAD_REQUEST;
        }

        Book book = {
            id: id,
            title: updatedBook.title,
            author: updatedBook.author,
            isbn: updatedBook.isbn,
            price: updatedBook.price,
            category: updatedBook.category
        };

        books[id.toString()] = book;
        return book;
    }

    // DELETE /books/{id} - Delete a book
    resource function delete books/[int id]() returns http:NoContent|http:NotFound {
        if !books.hasKey(id.toString()) {
            return http:NOT_FOUND;
        }

        _ = books.remove(id.toString());
        return http:NO_CONTENT;
    }
}
