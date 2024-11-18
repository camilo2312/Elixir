import matplotlib.pyplot as plt
import pandas as pd

# Crear los datos de la tabla
speedup = {
    'Versión': ['1', '2', '3', '4'],
    'uf20-01': [1.45, 21.84, 0.35, 0.34],
    'uf20-0100': [1.72, 20.15, 0.36, 0.33],
    'uf20-0200': [1.43, 21.56, 0.36, 0.34],
    'uf20-0400': [1.73, 20.64, 0.36, 0.34],
    'uf20-0600': [1.54, 20.68, 0.37, 0.34],
    'uf20-800': [1.47, 20.89, 0.35, 0.36],
    'uf20-0999': [1.49, 21.07, 0.33, 0.36],
    'uf20-01000': [1.35, 20.46, 0.34, 0.32],
}

# Convertir los datos a un DataFrame
df = pd.DataFrame(speedup).set_index('Versión')

# Graficar
df.T.plot(kind='line', marker='o')
plt.title("Gráfica de Speedup")
plt.xlabel("Conjunto de Datos")
plt.ylabel("Speedup")
plt.grid()

# Ajustar la escala del eje Y con intervalos de 0.5
plt.yticks(ticks=[i * 0.5 for i in range(0, 45)])  # Cambia el rango según tus valores máximos

plt.legend(title="Versión", loc="upper right")
plt.show()