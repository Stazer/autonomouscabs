#pragma once

#include <memory>

template<typename T>
class tcp_session : public std::enable_shared_from_this<T>
{
    public:
        ~tcp_session() = default;

        virtual void run() = 0;
};
