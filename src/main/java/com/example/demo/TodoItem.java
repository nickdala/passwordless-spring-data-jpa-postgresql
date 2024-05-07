package com.example.demo;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "todos")
public class TodoItem {

    public TodoItem() {
    }

    public TodoItem(String title, boolean completed) {
        this.title = title;
        this.completed = completed;
    }


    @Id
    @Column(name = "todo_id", nullable = false, updatable = false)
    @GeneratedValue
    private Long id;

    @NotBlank
    @Column(name="title")
    private String title;

    @Column(name="is_completed")
    private boolean completed;

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}
