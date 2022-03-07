package com.bruno.pedidos.controller;

import org.hibernate.cache.spi.support.AbstractReadWriteAccess.Item;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.bruno.pedidos.model.ItemPedido;
import com.bruno.pedidos.repository.ItemPedidoRepository;

@RestController
@RequestMapping("/itemPedido")
public class ItemPedidoController {

    @Autowired
    private ItemPedidoRepository itemPedidoRepository;
    
    @GetMapping("/")
    public List<ItemPedido> listar() {
        return itemPedidoRepository.findAll();
    }

    @GetMapping("/{id}")
    public Optional<ItemPedido> listarPorId(@PathVariable("id") Long id) {
        Optional<ItemPedido> itemPedido = itemPedidoRepository.findById(id);
        return itemPedido;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public List<ItemPedido> cadastrar(@RequestBody List<ItemPedido> itemPedido) {
        List<ItemPedido> response = (List<ItemPedido>) itemPedidoRepository.saveAll(itemPedido);
        return response;
    }

    @PutMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ItemPedido atualizar(@RequestBody ItemPedido itemPedido) {
        return itemPedidoRepository.save(itemPedido); 
    }

    @DeleteMapping
    @ResponseStatus(HttpStatus.CREATED)
    public List<ItemPedido> remover(@RequestBody ItemPedido itemPedido) {
        itemPedidoRepository.deleteById(itemPedido.getId());
        return itemPedidoRepository.findAll(); 
    }
}
