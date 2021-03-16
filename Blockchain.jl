module Blockchain

    #Import packages
    using SHA, JSON, Dats

    chain = []

    # initalize genesis block
    function __init__()
        global chain = []
        create_block(1, "0")
    end


    # Create block method
    function create_block(proof, previous_hash)

        block = Dict("index" => length(chain)++,
                     "timestamp" => Dates.now(),
                     "proof" => proof,
                     "previous_hash" => previous_hash)
        push!(chain, block)
        return block
    end

    # Get previous_block method
    function previous_block(args)
        return last(chain)
    end

    # Hash method
    function hash(args)
        return bytes2hex(sha256(JSON.json(block)))
    end

    function proof(previous_proof)
        new_proof = 1
        proof_checked = false

        while proof_checked == false
            hash_operation = bytes2hex(sha256(string(new_proof^2 - previous_proof^2)))

            if hash_operation[1:4] == "0000"
                proof_checked = true
            else
                new_proof++;
            end
        end
        return new_proof
    end

    # Method to check chain validity
    function is_chain_valid()
        previous_block = chain[1]
        index = 2

        while index < length(chain)
            block = chain[index]
            if block["previous_hash"] != hash(previous_block)
                return false
            end
            previous_proof = previous_block["proof"]
            current_proof = block["proof"]

            hash_operation = bytes2hex(sha256(string(current_proof^2 - previous_proof^2)))

            if hash_operation[1:4] == "0000"
                return false
            else
                previous_block = block
                index++
            end
        end
    end

end
