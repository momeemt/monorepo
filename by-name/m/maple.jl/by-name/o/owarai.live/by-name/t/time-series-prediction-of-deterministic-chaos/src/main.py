import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist


def lorenz(x, y, z, sigma=10, r=28, b=8 / 3, dt=0.01):
    dx = sigma * (y - x)
    dy = x * (r - z) - y
    dz = x * y - b * z
    x += dx * dt
    y += dy * dt
    z += dz * dt
    return x, y, z


def generate_lorenz_data(x0, y0, z0, num_steps, dt=0.01):
    data = []
    x, y, z = x0, y0, z0
    for _ in range(num_steps):
        x, y, z = lorenz(x, y, z, dt=dt)
        data.append(x)
    return data


data = generate_lorenz_data(0.0, 1.0, 1.05, 10000)


def embed_delay_coordinates(data, dimension, tau):
    n = len(data)
    embedded_data = np.zeros((n - (dimension - 1) * tau, dimension))
    for i in range(dimension):
        embedded_data[:, i] = data[i * tau : n - (dimension - 1) * tau + i * tau]
    return embedded_data


def fixed_epsilon_neighbors(embedded_data, target, epsilon, metric="euclidean"):
    distances = cdist([target], embedded_data, metric=metric)[0]
    nearest_indices = np.where(distances <= epsilon)[0]
    return nearest_indices, distances[nearest_indices]


def knn_epsilon_neighbors(embedded_data, target, k, epsilon, metric="euclidean"):
    distances = cdist([target], embedded_data, metric=metric)[0]
    sorted_indices = np.argsort(distances)
    nearest_indices = sorted_indices[:k]
    epsilon_indices = nearest_indices[distances[nearest_indices] <= epsilon]
    return epsilon_indices, distances[epsilon_indices]


def nonlinear_prediction(embedded_data, t, neighbors_indices, steps, weights=None):
    predictions = np.zeros((steps, embedded_data.shape[1]))

    for step in range(steps):
        step_predictions = []
        step_weights = []
        for i, neighbor in enumerate(neighbors_indices):
            if neighbor + step < len(embedded_data):
                step_predictions.append(embedded_data[neighbor + step])
                if weights is not None:
                    step_weights.append(weights[i])

        if step_predictions:
            if weights is None:
                predictions[step] = np.mean(step_predictions, axis=0)
            else:
                predictions[step] = np.average(
                    step_predictions, axis=0, weights=step_weights
                )
        else:
            predictions[step] = np.zeros_like(embedded_data[0])
    return predictions[:, 0]


start = 1000
steps = 1000
fixed_epsilon = 1.0
k = 5
dimension = 3
tau = 2
embedded_data = embed_delay_coordinates(data, dimension, tau)

fixed_epsilon_neighbors_indices, fixed_epsilon_distances = fixed_epsilon_neighbors(
    embedded_data, embedded_data[start], fixed_epsilon, metric="euclidean"
)
fixed_epsilon_predictions = nonlinear_prediction(
    embedded_data, start, fixed_epsilon_neighbors_indices, steps
)

knn_epsilon_neighbors_indices, knn_epsilon_distances = knn_epsilon_neighbors(
    embedded_data, embedded_data[start], k, fixed_epsilon, metric="euclidean"
)
knn_epsilon_predictions = nonlinear_prediction(
    embedded_data, start, knn_epsilon_neighbors_indices, steps
)

plt.figure(figsize=(12, 6))
plt.plot(range(start, start + steps), data[start : start + steps], label="Actual")
plt.plot(
    range(start, start + steps),
    fixed_epsilon_predictions,
    label="Epsilon Predicted",
    linestyle="--",
)
plt.plot(
    range(start, start + steps),
    knn_epsilon_predictions,
    label="k-NN and Epsilon Predicted",
    linestyle="--",
)
plt.xlabel("Time")
plt.ylabel("Value")
plt.legend()
plt.show()
