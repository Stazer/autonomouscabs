template<typename T>
inline tcp_session<T>::tcp_session(class application& application):
    _application(application)
{
}

template<typename T>
inline application& tcp_session<T>::application()
{
    return _application;
}

template<typename T>
inline const application& tcp_session<T>::application() const
{
    return _application;
}
