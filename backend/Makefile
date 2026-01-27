.PHONY: run build test lint clean help dev

# Variables
BINARY_NAME=api
MAIN_PATH=cmd/api/main.go
BUILD_DIR=bin

# Default target
help:
	@echo "WealthScope Backend - Available commands:"
	@echo ""
	@echo "  make run      - Run the server"
	@echo "  make dev      - Run with hot reload (requires air)"
	@echo "  make build    - Build the binary"
	@echo "  make test     - Run tests"
	@echo "  make lint     - Run linter"
	@echo "  make clean    - Remove build artifacts"
	@echo ""

# Run the server
run:
	go run $(MAIN_PATH)

# Development mode with hot reload
dev:
	@which air > /dev/null || (echo "Installing air..." && go install github.com/air-verse/air@latest)
	air

# Build the binary
build:
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PATH)
	@echo "Binary built: $(BUILD_DIR)/$(BINARY_NAME)"

# Run tests
test:
	go test -v -race -coverprofile=coverage.out ./...
	@echo "Coverage report generated: coverage.out"

# Run tests with coverage report
test-coverage: test
	go tool cover -html=coverage.out -o coverage.html
	@echo "HTML coverage report: coverage.html"

# Run linter
lint:
	@which golangci-lint > /dev/null || (echo "Installing golangci-lint..." && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest)
	golangci-lint run

# Format code
fmt:
	go fmt ./...
	goimports -w .

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# Download dependencies
deps:
	go mod download
	go mod tidy

# Verify dependencies
verify:
	go mod verify
