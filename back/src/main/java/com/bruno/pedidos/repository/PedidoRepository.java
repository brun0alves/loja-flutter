package com.bruno.pedidos.repository;

import javax.transaction.Transactional;

import com.bruno.pedidos.model.Pedido;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {

    @Query(value = "DELETE FROM item_pedido WHERE pedido_id = :id", nativeQuery = true)
    @Modifying
    @Transactional
    void removerProdutosPedido(@Param("id") Long id);

}
