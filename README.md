# Store Management APIs

A collection of REST APIs for managing different types of stores built with Ballerina programming language.

## Services Overview

This project provides two complete CRUD (Create, Read, Update, Delete) APIs:

### 📚 Book Store API

A comprehensive API for managing a book store inventory with features like:

- Complete CRUD operations for books
- Book validation (title, author required)
- In-memory storage
- Runs on port **8082**

### 🎬 Movie Store API

An enhanced API for managing a movie collection with advanced features like:

- Complete CRUD operations for movies
- Search functionality by title or director
- Partial updates (PATCH for ratings)
- Enhanced validation (rating range, release year)
- In-memory storage
- Runs on port **8083**

## Quick Start

### Running Book Store

```bash
bal run main.bal
```

Service will be available at: `http://localhost:8082/book-store`

### Running Movie Store

```bash
bal run movie-store.bal
```

Service will be available at: `http://localhost:8083/movie-store`
