package com.classpath.itemsapi.service;

import com.classpath.itemsapi.model.Item;
import org.springframework.boot.autoconfigure.condition.ConditionMessage;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@Service
public class ItemService {

    public Set<Item> fetchAll(){
        return new HashSet<>(
                Arrays.asList(
                 Item.builder().id(12).name("Cap").desc("A Nice cap").price(2000).build(),
                 Item.builder().id(13).name("Ball").desc("Cricket ball").price(500).build(),
                 Item.builder().id(14).name("Bat").desc("Cricket Bat").price(8000).build(),
                 Item.builder().id(15).name("Gloves").desc("A pair of gloves").price(2000).build()
                )
        );
    }

    public Item getItemById(long id){
        return Item.builder().id(12).name("cap").price(2000).desc("Nice cap").build();
    }
}
