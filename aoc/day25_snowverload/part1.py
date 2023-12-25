import io
from itertools import chain
from typing import Iterable

import networkx as nx


def get_edges_from_line(line: str) -> Iterable[tuple[str, str]]:
    node, neighbors = line.split(": ")
    return map(lambda n: (node, n), neighbors.split())


def main(data: io.TextIOWrapper) -> int:
    graph: nx.Graph[str] = nx.Graph(chain.from_iterable(map(get_edges_from_line, data)))
    graph.remove_edges_from(nx.minimum_edge_cut(graph))
    a, b = nx.connected_components(graph)
    return len(a) * len(b)
