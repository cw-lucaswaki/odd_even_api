
# Elixir Phoenix Odd-Even API

This project serves as a comprehensive study case for developing a simple yet robust API using Elixir and the Phoenix framework. It demonstrates key concepts in API development, testing, and DevOps practices.

## Project Overview

The Odd-Even API is a straightforward service that determines whether a given number is odd or even. While simple in concept, it showcases various backend development best practices and modern DevOps techniques.

### Key Features

- RESTful API endpoint for odd/even number checking
- Comprehensive test suite
- GitHub Actions for Continuous Integration
- Custom linting task
- API load testing script (planned)
- Kubernetes deployment setup (planned)
- Monitoring and logging (planned)

## Technology Stack

- **Language:** Elixir 1.15.2
- **Framework:** Phoenix 1.7.14
- **OTP Version:** 26.0
- **Database:** None (stateless API)
- **CI/CD:** GitHub Actions
- **Code Quality:** Credo, Custom Linter
- **HTTP Client:** Finch

## Project Structure

The project follows a standard Phoenix application structure with some custom additions:

```
odd_even_api/
├── lib/
│   ├── odd_even_api/
│   │   └── application.ex
│   ├── odd_even_api_web/
│   │   ├── controllers/
│   │   │   ├── error_json.ex
│   │   │   └── number_controller.ex
│   │   ├── router.ex
│   │   └── endpoint.ex
├── test/
│   └── odd_even_api_web/
│       └── controllers/
│           └── number_controller_tests.exs
├── .github/
│   └── workflows/
│       ├── elixir.yml
│       └── elixir-ci.yml
└── mix.exs
```

## Setup and Installation

1. Ensure you have Elixir 1.15.2 and Erlang/OTP 26.0 installed.
2. Clone the repository
3. Navigate to the `odd_even_api` directory
4. Run the following commands:

```bash
mix deps.get
mix phx.server
```

The server will start, and you can access the API at `http://localhost:4000`.

## API Usage

To check if a number is odd or even, send a GET request to:

```
GET /api/check/:number
```

Example response:
```json
{
  "number": 42,
  "result": "even"
}
```

## Development

The main API logic is implemented in `lib/odd_even_api_web/controllers/number_controller.ex`. The routing is defined in `lib/odd_even_api_web/router.ex`.

### Custom Linter

A custom linter task has been created to ensure code quality. You can run it using:

```bash
mix lint
```

This task combines Elixir's built-in formatter check with Credo's static code analysis.

## Testing

The test suite is located in the `test/` directory. To run the tests, use:

```bash
mix test
```

## Continuous Integration

The project uses GitHub Actions for CI/CD. Two workflow configurations are provided:

1. `elixir.yml`: Main CI pipeline
2. `elixir-ci.yml`: Additional checks including custom lint task

These workflows run on every push and pull request to the main branch, ensuring code quality and test coverage.

## API Attack

To run the API attack, use the following command:

```
URL=http://localhost:4000/api/check/42 NUM_REQUESTS=1000 CONCURRENCY=200 elixir api_attack.exs

```


## Future Enhancements

- Set up Kubernetes deployment
- Add monitoring and logging
- Enhance security measures

## Contributing

Contributions to improve the project or add new features are welcome. Please follow the standard GitHub fork and pull request workflow.

## License

This project is open-source and available under the MIT License.

---

This README provides a comprehensive overview of the Odd-Even API project, highlighting its structure, setup instructions, and development practices. It serves as an excellent study case for backend development with Elixir and Phoenix, showcasing both basic API functionality and advanced DevOps practices.
