// TODO: remove this when you're done with your implementation.
#![allow(unused_variables, dead_code)]
use std::ops::Add;

// Default gives us an empty, default constructor
#[derive(Clone, Copy, Debug, Default)]
pub struct Point {
    x: i32,
    y: i32, // add fields
}

/*
impl std::ops::Add for Point {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}
 */

impl std::ops::Sub for Point {
    type Output = Self;

    fn sub(self, other: Self) -> Self::Output {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

impl Add for Point {
    type Output = Point;
    fn add(self, other: Self) -> Self {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl PartialEq for Point {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}

impl Point {
    fn new(x: i32, y: i32) -> Self {
        Point { x, y }
    }

    // f64::from(self.x.pow(2) + self.y.pow(2)).sqrt()
    fn magnitude(&self) -> f64 {
        let x = (self.x * self.x) + (self.y * self.y);
        let y = x as f64;
        y.sqrt()
    }

    // (self - other).magnitude()
    fn dist(&self, p: Point) -> f64 {
        let x = (self.x - p.x).abs();
        let y = (self.y - p.y).abs();
        let z: f64 = ((x * x) + (y * y)) as f64;
        z.sqrt()
    }
}

// Default gives us an empty, default constructor
#[derive(Debug, Default)]
pub struct Polygon {
    points: Vec<Point>,
}

impl Polygon {
    pub fn new() -> Polygon {
        Polygon { points: Vec::new() }
    }

    pub fn add_point(&mut self, point: Point) {
        self.points.push(point);
    }

    fn left_most_point(&self) -> Option<&Point> {
        self.points.iter().min_by_key(|p| p.x)
    }

    pub fn iter(&self) -> impl Iterator<Item = &Point> {
        self.points.iter()
    }

    pub fn length(&self) -> f64 {
        if self.points.is_empty() {
            return 0.0;
        }

        let mut result = 0.0;
        let mut last_point = self.points[0];
        for point in &self.points[1..] {
            result += last_point.dist(*point);
            last_point = *point;
        }
        result += last_point.dist(self.points[0]);
        result
    }
}

#[derive(Debug, Default)]
pub struct Circle {
    center: Point,
    radius: i32,
}

impl Circle {
    fn new(center: Point, radius: i32) -> Circle {
        Circle { center, radius }
    }

    pub fn circumference(&self) -> f64 {
        2.0 * std::f64::consts::PI * f64::from(self.radius)
    }

    pub fn dist(&self, other: &Self) -> f64 {
        self.center.dist(other.center)
    }
}

pub enum Shape {
    Polygon(Polygon),
    Circle(Circle),
}

impl From<Polygon> for Shape {
    fn from(p: Polygon) -> Self {
        Shape::Polygon(p)
    }
}

impl From<Circle> for Shape {
    fn from(c: Circle) -> Self {
        Shape::Circle(c)
    }
}

impl Shape {
    fn circumference(&self) -> f64 {
        match self {
            Shape::Circle(c) => c.circumference(),
            Shape::Polygon(p) => p.length(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn round_two_digits(x: f64) -> f64 {
        (x * 100.0).round() / 100.0
    }

    #[test]
    fn test_point_magnitude() {
        let p1 = Point::new(12, 13);
        assert_eq!(round_two_digits(p1.magnitude()), 17.69);
    }

    #[test]
    fn test_point_dist() {
        let p1 = Point::new(10, 10);
        let p2 = Point::new(14, 13);
        assert_eq!(round_two_digits(p1.dist(p2)), 5.00);
    }

    #[test]
    fn test_point_add() {
        let p1 = Point::new(16, 16);
        let p2 = p1 + Point::new(-4, 3);
        assert_eq!(p2, Point::new(12, 19));
    }

    #[test]
    fn test_polygon_left_most_point() {
        let p1 = Point::new(12, 13);
        let p2 = Point::new(16, 16);

        let mut poly = Polygon::new();
        poly.add_point(p1);
        poly.add_point(p2);
        assert_eq!(poly.left_most_point(), Some(&p1));
    }

    #[test]
    fn test_polygon_iter() {
        let p1 = Point::new(12, 13);
        let p2 = Point::new(16, 16);

        let mut poly = Polygon::new();
        poly.add_point(p1);
        poly.add_point(p2);

        let points = poly.iter().cloned().collect::<Vec<_>>();
        assert_eq!(points, vec![Point::new(12, 13), Point::new(16, 16)]);
    }

    #[test]
    fn test_shape_circumferences() {
        let mut poly = Polygon::new();
        poly.add_point(Point::new(12, 13));
        poly.add_point(Point::new(17, 11));
        poly.add_point(Point::new(16, 16));
        let shapes = vec![
            Shape::from(poly),
            Shape::from(Circle::new(Point::new(10, 20), 5)),
        ];
        let circumferences = shapes
            .iter()
            .map(Shape::circumference)
            .map(round_two_digits)
            .collect::<Vec<_>>();
        assert_eq!(circumferences, vec![15.48, 31.42]);
    }
}

#[allow(dead_code)]
fn main() {}
