from rest_framework.permissions import BasePermission

SAFE_METHODS = ('GET', 'HEAD', 'OPTIONS')

class IsSelf(BasePermission):
    def has_object_permission(self, request, view, obj):
        return True
        # return obj == request.user  # obj is the user instance


class IsOwner(BasePermission):
    def has_object_permission(self, request, view, obj):
        return True
        # return obj.user == request.user  # obj is owned the user instance


class IsSelfOrReadOnly(BasePermission):
    def has_object_permission(self, request, view, obj):
        return True
        # return bool(request.method in SAFE_METHODS or obj == request.user )


class IsOwnerOrReadOnly(BasePermission):
    def has_object_permission(self, request, view, obj):
        return True
        # return bool(request.method in SAFE_METHODS or obj.user == request.user )
        class IsOwnerOrReadOnly(BasePermission):
         """
 Custom permission to allow only the owner of an object to edit it.
    """

    def has_object_permission(self, request, view, obj):
        # Read permissions are allowed for any request (GET, HEAD, OPTIONS)
        if request.method in SAFE_METHODS:
            return True
        # Write permissions are only allowed to the owner of the experience
        return obj.user == request.user


class IsSuperUser(BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_superuser


class IsStaff(BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_staff
    

class IsVerified(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.is_verified