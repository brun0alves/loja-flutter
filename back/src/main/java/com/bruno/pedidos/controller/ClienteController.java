package com.bruno.pedidos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Optional;

import com.bruno.pedidos.model.Cliente;
import com.bruno.pedidos.model.HttpResponse;
import com.bruno.pedidos.repository.ClienteRepository;

@RestController
@RequestMapping("/cliente")
public class ClienteController {

    @Autowired
    private ClienteRepository clienteRepository;
    
    @GetMapping("/")
    public ResponseEntity<?> listar() {
        HttpResponse response = new HttpResponse();
        response.setStatus(HttpStatus.OK);

        return new ResponseEntity<>(clienteRepository.findAll(), response.getStatus());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> listarPorId(@PathVariable("id") Long id) {
        HttpResponse response = new HttpResponse();

        try {
            Optional<Cliente> cliente = clienteRepository.findById(id);
            response.setStatus(HttpStatus.OK);
            
            return new ResponseEntity<>(cliente, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }

    @PostMapping
    public ResponseEntity<?> cadastrar(@RequestBody Cliente cliente) {
        HttpResponse response = new HttpResponse();

        try {
            if(clienteRepository.verificaCpfUnico(cliente.getCpf(), cliente.getId()) > 0) {
                throw new Exception("Erro ao cadastrar o Cliente. Motivo: Ja existe um cliente com o CPF " + cliente.getCpf() + " cadastrado no sistema.");
            }

            clienteRepository.save(cliente);
            response.setStatus(HttpStatus.CREATED);
            response.setMessage("Cliente cadastrado com sucesso.");

            return new ResponseEntity<>(response, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> atualizar(@PathVariable("id") Long id, @RequestBody Cliente cliente) {
        HttpResponse response = new HttpResponse();

        try {
            if(clienteRepository.verificaCpfUnico(cliente.getCpf(), cliente.getId()) > 0) {
                throw new Exception("Erro ao atualizar o Cliente. Motivo: Ja existe um cliente com o CPF " + cliente.getCpf() + " cadastrado no sistema.");
            }

            clienteRepository.save(cliente);
            response.setStatus(HttpStatus.OK);
            response.setMessage("Cliente atualizado com sucesso.");

            return new ResponseEntity<>(response, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> remover(@PathVariable("id") Long id) {
        HttpResponse response = new HttpResponse();

        try {

            if(clienteRepository.verificaPedidoCliente(id) > 0) {
                throw new Exception("Erro ao deletar o Cliente. Motivo: Ele possui pedidos cadastrados no sistema.");
            }
            clienteRepository.deleteById(id);
            response.setStatus(HttpStatus.OK);
            response.setMessage("Cliente deletado com sucesso.");

            return new ResponseEntity<>(response, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }
}
