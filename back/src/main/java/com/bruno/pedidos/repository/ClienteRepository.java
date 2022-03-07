package com.bruno.pedidos.repository;

import com.bruno.pedidos.model.Cliente;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long> {

    @Query(value = "SELECT count(*) FROM cliente WHERE trim(cpf) = trim(:cpf) and id <> :id", nativeQuery = true)
    Integer verificaCpfUnico(@Param("cpf") String cpf, @Param("id") Long id);

    @Query(value = "SELECT count(*) FROM pedido WHERE cliente_id = :id", nativeQuery = true)
    Integer verificaPedidoCliente(@Param("id") Long id);

}