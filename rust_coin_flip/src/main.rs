use rand::Rng;
use rand::SeedableRng;

#[derive(Debug, PartialEq, Eq)]
pub enum Coin {
    Heads,
    Tails,
}

impl std::fmt::Display for Coin {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Coin::Heads => write!(f, "Heads"),
            Coin::Tails => write!(f, "Tails"),
        }
    }
}

pub fn flip_coin<R: Rng>(rng: &mut R) -> Coin {
    if rng.gen_bool(0.5) {
        Coin::Heads
    } else {
        Coin::Tails
    }
}

fn main() {
    let mut rng = rand::thread_rng();
    let result = flip_coin(&mut rng);
    println!("The coin landed on: {}", result);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_flip_coin_valid() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(42);
        let coin = flip_coin(&mut rng);
        assert!(coin == Coin::Heads || coin == Coin::Tails);
    }

    #[test]
    fn test_coin_display() {
        assert_eq!(format!("{}", Coin::Heads), "Heads");
        assert_eq!(format!("{}", Coin::Tails), "Tails");
    }

    #[test]
    fn test_multiple_flips() {
        let mut rng = rand::thread_rng();
        let mut heads_count = 0;
        let mut tails_count = 0;
        for _ in 0..100 {
            match flip_coin(&mut rng) {
                Coin::Heads => heads_count += 1,
                Coin::Tails => tails_count += 1,
            }
        }
        assert!(heads_count > 0);
        assert!(tails_count > 0);
        assert_eq!(heads_count + tails_count, 100);
    }
}
