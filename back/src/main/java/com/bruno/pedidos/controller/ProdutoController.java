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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import java.util.Optional;

import com.bruno.pedidos.model.HttpResponse;
import com.bruno.pedidos.model.Produto;
import com.bruno.pedidos.repository.ProdutoRepository;

@RestController
@RequestMapping("/produto")
public class ProdutoController {

    @Autowired
    private ProdutoRepository produtoRepository;
    
    @GetMapping("/")
    public ResponseEntity<?> listar() {
        HttpResponse response = new HttpResponse();
        response.setStatus(HttpStatus.OK);

        return new ResponseEntity<>(produtoRepository.findAll(), response.getStatus());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> listarPorId(@PathVariable("id") Long id) {
        HttpResponse response = new HttpResponse();

        try {
            Optional<Produto> produto = produtoRepository.findById(id);
            response.setStatus(HttpStatus.OK);
            
            return new ResponseEntity<>(produto, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }

    }

    @PostMapping
    public ResponseEntity<?> cadastrar(@RequestBody Produto produto) {
        HttpResponse response = new HttpResponse();

        try {
            if(produtoRepository.verificaProdutoExistente(produto.getId(), produto.getDescricao()) > 0) {
                throw new Exception("Erro ao cadastrar o produto " + produto.getDescricao() + ". Motivo: Já existe um produto com essa descrição.");
            }

            produtoRepository.save(produto);
            response.setStatus(HttpStatus.CREATED);
            response.setMessage("Produto cadastrado com sucesso.");

            return new ResponseEntity<>(response, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }

    @PutMapping
    public ResponseEntity<?> atualizar(@RequestBody Produto produto) {
        HttpResponse response = new HttpResponse();

        try {
            if(produtoRepository.verificaProdutoExistente(produto.getId(), produto.getDescricao()) > 0) {
                throw new Exception("Erro ao cadastrar o produto " + produto.getDescricao() + ". Motivo: Já existe um produto com essa descrição.");
            }

            produtoRepository.save(produto);
            response.setStatus(HttpStatus.OK);
            response.setMessage("Produto atualizado com sucesso.");

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
            if(produtoRepository.verificaPedidoProduto(id) > 0) {
                throw new Exception("Erro ao deletar o Produto. Motivo: Ele possui pedidos cadastrados no sistema.");
            }
            produtoRepository.deleteById(id);
            response.setStatus(HttpStatus.OK);
            response.setMessage("Produto deletado com sucesso.");

            return new ResponseEntity<>(response, response.getStatus());
        }catch(Exception e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            response.setMessage(e.getMessage());
            return new ResponseEntity<>(response, response.getStatus());
        }
    }
}
