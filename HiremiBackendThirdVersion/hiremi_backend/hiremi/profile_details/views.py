from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets
from .models import Experience, Project, SocialLink, Education, Language
from .serializers import (ExperienceSerializer, ProjectSerializer, 
                        SocialLinkSerializer, EducationSerializer, LanguageSerializer)
from accounts.permissions import IsOwner, IsOwnerOrReadOnly
from rest_framework import viewsets, permissions, filters
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from django_filters.rest_framework import DjangoFilterBackend
from .models import Experience
from .serializers import ExperienceSerializer
# from .permissions import IsOwnerOrReadOnly  
from rest_framework import serializers

from accounts.permissions import IsOwnerOrReadOnly

# class ExperienceViewSet(viewsets.ModelViewSet):
#     queryset = Experience.objects.all()
#     serializer_class = ExperienceSerializer
#     # permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
#     permission_classes = [permissions.AllowAny]  

#     filterset_fields = ["user", "company_name", "job_title"]
#     search_fields = ["company_name", "job_title"]
#     ordering_fields = []

#     def perform_create(self, serializer):
#         serializer.save(user=self.request.user)

#     def perform_update(self, serializer):
#         serializer.save(user=self.request.user)
from rest_framework.permissions import IsAuthenticated

class ExperienceViewSet(viewsets.ModelViewSet):
    queryset = Experience.objects.all()
    serializer_class = ExperienceSerializer
    permission_classes = [IsAuthenticated]  # Require authentication

    filterset_fields = ["user", "company_name", "job_title"]
    search_fields = ["company_name", "job_title"]
    ordering_fields = []

    def perform_create(self, serializer):
        if not self.request.user.is_authenticated:
            raise serializers.ValidationError("User must be authenticated.")
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        if not self.request.user.is_authenticated:
            raise serializers.ValidationError("User must be authenticated.")
        serializer.save(user=self.request.user)

# class ExperienceViewSet(viewsets.ModelViewSet):
#     """
#     API endpoint that allows users to create, retrieve, update, and delete their experiences.
#     """
#     queryset = Experience.objects.all()
#     serializer_class = ExperienceSerializer
#     permission_classes = [permissions.AllowAny]  
#     authentication_classes = [TokenAuthentication, SessionAuthentication]  # Supports both Token & Session Auth

#     # Filtering and searching
#     filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
#     filterset_fields = ["user", "company_name", "job_title"]  # Filters by user, company name, job title
#     search_fields = ["company_name", "job_title"]  # Enables search functionality
#     ordering_fields = ["start_date", "end_date"]  # Allows ordering by date

#     def perform_create(self, serializer):
#         """
#         Ensures that the user field is automatically assigned to the authenticated user.
#         """
#         serializer.save(user=self.request.user)

#     def perform_update(self, serializer):
#         """
#         Ensures that only the owner can update their experience details.
#         """
#         serializer.save(user=self.request.user)


class ProjectViewSet(viewsets.ModelViewSet):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
    # permission_classes = [permissions.AllowAny]  

    filterset_fields = ["user"]
    search_fields = ["name"]
    ordering_fields = []

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        serializer.save(user=self.request.user)

class SocialLinkViewSet(viewsets.ModelViewSet):
    queryset = SocialLink.objects.all()
    serializer_class = SocialLinkSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
    # permission_classes = [permissions.AllowAny]  

    filterset_fields = ["user", "platform"]
    ordering_fields = []

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        serializer.save(user=self.request.user)
    

class EducationViewSet(viewsets.ModelViewSet):
    queryset = Education.objects.all()
    serializer_class = EducationSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
    filterset_fields = ["user", "degree", "branch", "passing_year","college_name","college_state","college_city"]
    search_fields = ["college_name", "branch", "degree"]
    ordering_fields = ["passing_year"]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        serializer.save(user=self.request.user)


class LanguageViewSet(viewsets.ModelViewSet):
    serializer_class = LanguageSerializer
    # permission_classes = [IsStaff]
    queryset = Language.objects.all()