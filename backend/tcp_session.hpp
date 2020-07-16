#pragma once

#include <memory>

class application;

template<typename T>
class tcp_session : public std::enable_shared_from_this<T>
{
    public:
        tcp_session(application& application);
        tcp_session(tcp_session<T>&) = delete;
        tcp_session(tcp_session<T>&&) = default;
        tcp_session<T>& operator=(const tcp_session<T>&) = delete;
        tcp_session<T>& operator=(tcp_session<T>&&) = default;

        virtual ~tcp_session() = default;

        virtual void run() = 0;


    protected:
        application& application();
        const class application& application() const;

    private:
        class application& _application;
};

#include "tcp_session.inl"
