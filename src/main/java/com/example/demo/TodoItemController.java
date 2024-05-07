package com.example.demo;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/todos")
public class TodoItemController {
    private final TodoItemRepository repository;

    public TodoItemController(TodoItemRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<TodoItemDto> index() {
        List<TodoItemDto> todos = convertToDto(repository.findAll());
        return todos;
    }

    @GetMapping("/active")
    public List<TodoItemDto> indexActive(Model model) {
        List<TodoItemDto> todos = convertToDto(repository.findAllByCompleted(false));
        return todos;
    }

    @GetMapping("/completed")
    public List<TodoItemDto> indexCompleted(Model model) {
        List<TodoItemDto> todos = convertToDto(repository.findAllByCompleted(true));
        return todos;
    }

    @PostMapping
    public TodoItemDto addNewTodoItem(@RequestBody NewTodoItemDto newTodoItemDto) {
        TodoItem todoItem = repository.save(new TodoItem(newTodoItemDto.title(), false));

        return toDto(todoItem);
    }

    private List<TodoItemDto> convertToDto(List<TodoItem> todoItems) {
        return todoItems
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    private TodoItemDto toDto(TodoItem todoItem) {
        return new TodoItemDto(todoItem.getId(),
                               todoItem.getTitle(),
                               todoItem.isCompleted());
    }
}
