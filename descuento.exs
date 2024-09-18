defmodule Descuento do
  def main do
    valor_producto = "Ingrese el valor del producto"
    |> Util.ingresar(:entero)

    porcentaje_descuento = "Ingrese el valor del descuento entre 0.0 y 1.0"
    |> Util.ingresar(:real)

    valor_descuento = calcular_valor_descuento(porcentaje_descuento, valor_producto)
    valor_pagado = calcular_valor_pagado(valor_descuento, valor_producto)
    generar_mensaje(valor_descuento, valor_pagado)
    |> Util.mostrar_mensaje()
  end

  defp calcular_valor_descuento(porcentaje_descuento, valor_producto) do
    porcentaje_descuento * valor_producto
  end

  defp calcular_valor_pagado(valor_descuento, valor_pagado) do
    valor_pagado - valor_descuento
  end

  defp generar_mensaje(descuento_aplicado, valor_pagado) do
    valor_pagado_string = :erlang.float_to_binary(valor_pagado, [:compact, decimals: 2])
    valor_descuento_string = :erlang.float_to_binary(descuento_aplicado, [:compact, decimals: 2])
    "El descuento aplicado fue de $#{valor_descuento_string}
    y el valor a pagar es: $#{valor_pagado_string}"
  end
end

Descuento.main()
