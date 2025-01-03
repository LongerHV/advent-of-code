pub type Point =
  #(Int, Int)

pub fn add(p1: Point, p2: Point) -> Point {
  #(p1.0 + p2.0, p1.1 + p2.1)
}

pub fn sub(p1: Point, p2: Point) -> Point {
  #(p1.0 - p2.0, p1.1 - p2.1)
}

pub fn mul(p: Point, n: Int) -> Point {
  #(p.0 * n, p.1 * n)
}
