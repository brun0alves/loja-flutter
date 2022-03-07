package com.bruno.pedidos.repository;

import com.bruno.pedidos.model.Produto;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long> {

    @Query(value = "SELECT count(*) FROM produto WHERE trim(lower(descricao)) = trim(lower(:descricao)) and id <> :id", nativeQuery = true)
    Integer verificaProdutoExistente(@Param("id") Long id, @Param("descricao") String descricao);

    
    @Query(value = "SELECT count(*) FROM item_pedido WHERE produto_id = :id", nativeQuery = true)
    Integer verificaPedidoProduto(@Param("id") Long id);
}