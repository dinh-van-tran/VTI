# Use an official Golang runtime for build app.
FROM golang:1.16-alpine AS build

# Set the working directory to /app
WORKDIR /app

# Copy the source code  into the container at /app
COPY server.go /app

# Build the Go app
RUN go build -o server server.go 

# Use ligter container for running
FROM alpine:latest

# Copy the executable file
COPY --from=build /app/* /app/

# Set the working directory to /app
WORKDIR /app

# Expose port 8080
EXPOSE 8080

# Run the Go app when the container starts
CMD ["./server"]
