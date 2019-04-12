module Similarity

    #data1,data2に配列かハッシュを渡すと類似度が返る
    def calculate_similarity(data1,data2,type="cosine")
      if data1.class==Array
        calculate_similarity_with_array(data1,data2,type)
      elsif data1.class==Hash
        calculate_similarity_with_hash(data1,data2,type)
      end
    end
  
    #vector1とvector2に同じ長さの数列(要素が数字の配列)を渡すと類似度が返る
    #第三引数のtypeに"cosine","jaccard","dice"のいずれかを指定する(default="cosine")
    def calculate_similarity_with_array(vector1,vector2,type="cosine")
      if type=="cosine"   
        #コサイン類似度を計算
        similarity = cosine_similarity(vector1,vector2)
      elsif type=="jaccard"
        #Jaccard係数を計算
        similarity = jaccard_similarity(vector1,vector2)
      elsif type=="dice"
        #Dice係数を計算
        similarity = dice_similarity(vector1,vector2)
      end
      return similarity #類似度を返す
    end
  
    #hash1とhash2に比較したいhashを渡すと類似度が返る
    #二つのhashは異なる長さ、keyを持っていてもkeyを統合して長さが調整される
    def calculate_similarity_with_hash(hash1,hash2,type="cosine")
      hash3 = hash1.merge(hash2)
      hash3.each do |key,value|
        hash1[key] = 0 if hash1[key].blank?
        hash2[key] = 0 if hash2[key].blank?
      end
      vector1 = hash1.sort.map{|key,val|val}
      vector2 = hash2.sort.map{|key,val|val}
      if type=="cosine"   
        #コサイン類似度を計算
        similarity = cosine_similarity(vector1,vector2)
      elsif type=="jaccard"
        #Jaccard係数を計算
        similarity = jaccard_similarity(vector1,vector2)
      elsif type=="dice"
        #Dice係数を計算
        similarity = dice_similarity(vector1,vector2)
      end
      return similarity #類似度を返す
    end
  
    #コサイン類似度[START]
    def cosine_similarity(vector1, vector2)
      dp = dot_product(vector1, vector2)
      nm = normalize(vector1) * normalize(vector2)
      dp / nm
    end
  
    def dot_product(vector1, vector2)
      sum = 0.0
      vector1.each_with_index{ |val, i| sum += val*vector2[i] }
      sum
    end
  
    def normalize(vector)
      Math.sqrt(vector.inject(0.0){ |m,o| m += o**2 })
    end
    #コサイン類似度[END]
  
    #Jaccard係数[START]
    def jaccard_similarity(vector1,vector2)
      numerator = 0
      denominator = 0
  
      vector1.each_with_index do |val1,index|
        val2 = vector2[index]
        numerator += [val1,val2].min
        denominator += [val1,val2].max
      end
      return denominator != 0 ? numerator.to_f / denominator : 0
    end
    #Jaccard係数[END]
  
    #Dice係数[START]
    def dice_similarity(vector1,vector2)
      numerator = 0
      denominator = 0
      vector1.each_with_index do |val1,index|
        val2 = vector2[index]
        numerator += [val1,val2].min
        denominator += val1+val2
      end
      return denominator != 0 ? 2 * numerator.to_f / denominator : 0
    end
    #Dice係数[END]
  end

  def calculate_similarity(class_name, columns={}, type="cosine")

    similarity_matrix = []

    class_name.find_each do |obj1|

      similarity_matrix_child = []
      obj1_ary = []

      columns.each do |column|
        begin
          obj1_ary << eval("obj1.#{column[0].to_s}").to_i * column[1].to_i
        rescue
          obj1_ary << 0
        end
      end

      class_name.find_each do |obj2|
        obj2_ary = []
        columns.each do |column|
          begin
            obj2_ary << eval("obj2.#{column[0].to_s}").to_i * column[1].to_i
          rescue
            obj2_ary << 0
          end
        end

        if type=="cosine"
          #obj1とobj2のコサイン類似度を配列に入れる
          similarity_matrix_child << cosine_similarity(obj1_ary,obj2_ary)
        elsif type=="jaccard"
          #obj1とobj2のJaccard係数を配列に入れる
          similarity_matrix_child << jaccard_similarity(obj1_ary,obj2_ary)

        elsif type=="dice"
          #obj1とobj2のDice係数を配列に入れる
          similarity_matrix_child << dice_similarity(obj1_ary,obj2_ary)
        end
      end
      similarity_matrix << similarity_matrix_child
    end
    return similarity_matrix #最終的に行列の形で類似度を返す
  end
end