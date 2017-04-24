class Cipher
  def gcd(a, b)
    if b == 0
      return a
    else
      return gcd(b, a % b)
    end
  end

  # input, start
  def find_coprime(a, z)
    return z if gcd(a, z) == 1
    find_coprime(a, z + 1)
  end

  def genkey(d, l)
    (1..Float::INFINITY).lazy.find { |k| ((k * d) % l) == 1 }
  end

  def encrypt_string(string)
    len = string.length
    return [string, 0, 1] if len <= 2

    # x coprime len
    #x = (2...len).to_a.shuffle.find { |num| gcd(len, num) == 1 }
    #decrypt_key = len - x
    decrypt_key = (2...len).to_a.shuffle.find { |num| gcd(len, num) == 1 }
    x = len - decrypt_key
    padding = rand(1...len)
    decrypt_padding = (padding * x) % len

    key = genkey(decrypt_key, len)

    encrypted = ""
    idx = padding
    while encrypted.length < len
      encrypted << string[idx]
      idx = (idx + key) % len
    end

    [encrypted, mutate_key(decrypt_padding, len), mutate_key(decrypt_key, len)]
  end

  def decrypt_string(string, padding, key)
    len = string.length
    return string if len.zero?
    decrypted = ""
    idx = padding % len
    while decrypted.length < len
      decrypted << string[idx]
      idx = (idx + key) % len
    end
    decrypted
  end

  def mutate_key(k, len)
    (len * rand(1..10)) + k
  end

  def simple_crypt(input_string)
    alnum = [*('a'..'z'), *('A'..'Z'), *('0'..'9'), ' ']
    alnum = alnum - input_string.chars.uniq
    key = ""
    output_string = input_string.chars.map do |char|
      random_chars = alnum.sample(rand(1..2)).join("")
      key << random_chars
      if rand(0..1).zero?
        random_chars + char
      else
        char + random_chars
      end
    end.join("")
    key = key.chars.uniq.shuffle.join("")
    [output_string.reverse, key]
  end
end
