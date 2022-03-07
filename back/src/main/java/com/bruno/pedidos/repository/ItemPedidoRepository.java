package com.bruno.pedidos.repository;

import javax.transaction.Transactional;

import com.bruno.pedidos.model.ItemPedido;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemPedidoRepository extends JpaRepository<ItemPedido, Long> {

    @Query(value = "DELETE from item_pedido where pedido_id = :id", nativeQuery = true)
    @Modifying
    @Transactional
    void deleteByIdPedido(@Param("id") Long id);

}