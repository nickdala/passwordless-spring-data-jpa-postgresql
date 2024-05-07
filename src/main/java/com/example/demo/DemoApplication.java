package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	// Seed the database with some data
	//@Bean
	public CommandLineRunner demo(TodoItemRepository repository) {
		return (args) -> {
			repository.deleteAll();
			// save a few employees
			repository.save(new TodoItem("Paint the house", false));
		};
	}
}
