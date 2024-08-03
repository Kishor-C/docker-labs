package com.classpath.itemsapi.model;

import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@EqualsAndHashCode(of = "id")
@Builder
public class Item {

    private long id;
    private String name;
    private String desc;
    private double price;

}
