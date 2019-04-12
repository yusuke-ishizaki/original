
class Similarity
  def sim_distance(prefs, person1, person2)
      shared_items_a = shared_items_a(prefs, person1, person2)
      return 0 if shared_items_a.size == 0
      sum_of_squares = shared_items_a.inject(0) {|result, item|
        result + (prefs[person1][item]-prefs[person2][item])**2
      }
      return 1/(1+sum_of_squares)
    end
    
    def sim_pearson(prefs, person1, person2)
      shared_items_a = shared_items_a(prefs, person1, person2)
    
      n = shared_items_a.size
      return 0 if n == 0
    
      sum1 = shared_items_a.inject(0) {|result,si|
        result + prefs[person1][si]
      }
      sum2 = shared_items_a.inject(0) {|result,si|
        result + prefs[person2][si]
      }
      sum1_sq = shared_items_a.inject(0) {|result,si|
        result + prefs[person1][si]**2
      }
      sum2_sq = shared_items_a.inject(0) {|result,si|
        result + prefs[person2][si]**2
      }
      sum_products = shared_items_a.inject(0) {|result,si|
        result + prefs[person1][si]*prefs[person2][si]
      }
    
      num = sum_products - (sum1*sum2/n)
      den = Math.sqrt((sum1_sq - sum1**2/n)*(sum2_sq - sum2**2/n))
      return 0 if den == 0
      return num/den
    end
    
    def self.top_matches(prefs, person, n=5, similarity=:sim_pearson)
      scores = Array.new
      prefs.each do |key,value|
        if key != person
          scores << [__send__(similarity,prefs,person,key),key]
        end
      end
      return scores.sort.reverse[0,n]
    end
    
    def get_recommendations(prefs, person, similarity=:sim_pearson)
      totals_h = Hash.new(0)
      sim_sums_h = Hash.new(0)
    
      prefs.each do |other,val|
        next if other == person
        sim = __send__(similarity,prefs,person,other)
        next if sim <= 0
        prefs[other].each do |item, val|
          if !prefs[person].keys.include?(item) || prefs[person][item] == 0
            totals_h[item] += prefs[other][item]*sim
            sim_sums_h[item] += sim
          end
        end
      end
    
      rankings = Array.new
      totals_h.each do |item,total|
        rankings << [total/sim_sums_h[item], item]
      end
      return rankings.sort.reverse
    end
    
    def transform_prefs(prefs)
      result = Hash.new
      prefs.each do |person,score_h|
        score_h.each do |item,score|
          result[item] ||= Hash.new
          result[item][person] = score
        end
      end
      result
    end
    
    def shared_items_a(prefs, person1, person2)
      prefs[person1].keys & prefs[person2].keys
    end
  end

