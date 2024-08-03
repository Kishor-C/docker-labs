package com.classpath.itemsapi.controller;

import com.classpath.itemsapi.model.Item;
import com.classpath.itemsapi.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;

@RestController
@RequestMapping("/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @GetMapping
    public Set<Item> fetchItems(){
        return this.itemService.fetchAll();
    }

    @GetMapping("/{id}")
    public Item findById(@PathVariable("id") long id) {
        return this.itemService.getItemById(id);
    }

}
