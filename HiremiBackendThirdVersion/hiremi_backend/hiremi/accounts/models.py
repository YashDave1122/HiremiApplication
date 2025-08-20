from decimal import Decimal
import random
from datetime import timedelta, timezone

from django.contrib.auth import get_user_model
from django.contrib.auth.models import (AbstractBaseUser, BaseUserManager,
                                        PermissionsMixin)
from django.db import models
from django.forms import ValidationError
from django.utils.timezone import now
from phonenumber_field.modelfields import PhoneNumberField

from .managers import AccountManager
from django.utils import timezone

from django.core.validators import MinValueValidator, MaxValueValidator

# from accounts.models import State



# Create your models here.
# class State(models.Model):
#     name = models.CharField(primary_key=True, max_length=50)

#     def __str__(self):
#         return self.name


# class City(models.Model):
#     name = models.CharField(max_length=50)
#     state = models.ForeignKey(
#         State, on_delete=models.SET_NULL, related_name="state_cities", null=True
#     )

#     def __str__(self):
#         return f"{self.name} - {self.state}"

#     class Meta:
#         verbose_name_plural = "cities"
#         unique_together = ["name", "state"]

class State(models.Model):
    name = models.CharField(max_length=100, unique=True, primary_key=True)

    def __str__(self):  # Fixed the method name
        return self.name

class City(models.Model):
    name = models.CharField(max_length=100)
    state = models.ForeignKey(State, related_name='cities', on_delete=models.CASCADE)

    # def str(self):
    def _str_(self):  # ✅ Correct (double underscores)
        return f"{self.name}, {self.state.name}"


class Account(AbstractBaseUser, PermissionsMixin):
    SUPER_ADMIN = "Super Admin"
    HR = "HR"
    APPLICANT = "Applicant"
    MALE = "Male"
    FEMALE = "Female"
    OTHER = "Other"
    PAYMENT_STATUS_CHOICES = (
        ('Not Enroll', 'Not Enroll'),
        ('Enroll Pending', 'Enroll Pending'),
        ('Enrolled', 'Enrolled'),
    )
    unique = models.CharField(max_length=8, unique=True, null=True, blank=True)
    payment_status = models.CharField(max_length=15, choices=PAYMENT_STATUS_CHOICES, default='Not Enroll')
    verified = models.BooleanField(default=False)


    ROLE_CHOICES = [(SUPER_ADMIN, SUPER_ADMIN), (HR, HR), (APPLICANT, APPLICANT)]
    GENDER_CHOICES = [(MALE, MALE), (FEMALE, FEMALE), (OTHER, OTHER)]

    email = models.EmailField(unique=True)
    full_name = models.CharField(max_length=200)
    
    father_name = models.CharField(max_length=200)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    date_of_birth = models.DateField()
    current_state = models.ForeignKey(
        State, on_delete=models.SET_NULL, null=True, related_name="state_users"
    )
    current_city = models.ForeignKey(
        City, on_delete=models.SET_NULL, null=True, related_name="city_users"
    )

    phone_number = PhoneNumberField()

    birth_state = models.ForeignKey(
        State,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="state_born_users",
    )
    birth_city = models.ForeignKey(
        City,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="city_born_users",
    )
    whatsapp_number = PhoneNumberField(null=True, blank=True)
    current_pincode = models.CharField(max_length=10, null=True, blank=True)

    career_stage = models.CharField(max_length=20, null=True, blank=True)

    is_differently_abled = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)

    role = models.CharField(max_length=15, choices=ROLE_CHOICES, default=APPLICANT)

    # needed for django admin
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    date_joined = models.DateTimeField(verbose_name="date joined", auto_now_add=True)
    last_login = models.DateTimeField(verbose_name="last login", auto_now=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["full_name", "phone_number", "father_name", "gender", "date_of_birth"]

    objects = AccountManager()

    def __str__(self):
        return f"{self.id} - {self.full_name}"


# This model will store the OTPs sent to users and manage their validation
class EmailOTP(models.Model):
    email = models.EmailField(primary_key=True)
    otp = models.CharField(max_length=4, default=None, null=True, blank=True)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def can_be_regenerated(self):
        # OTP can be regenerated after a fixed time limit
        return now() > self.created_at + timedelta(minutes=2)

    def is_valid(self, time_limit=5):
        # Used to check OTP expiry and registration time limit
        return now() < self.created_at + timedelta(minutes=time_limit)

    def __str__(self):
        return f"OTP for {self.email}: {self.otp}"

    @staticmethod
    def generate_otp():
        return str(random.randint(1000, 9999))

    def refresh_otp(self):
        self.otp = self.generate_otp()
        self.created_at = now()
        self.is_verified = False
        self.save()
        return self.otp

class PasswordResetOTP(models.Model):
    email = models.EmailField(primary_key=True)
    otp = models.CharField(max_length=4, default=None, null=True, blank=True)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def can_be_regenerated(self):
        # OTP can be regenerated after a fixed time limit
        return now() > self.created_at + timedelta(minutes=2)

    def is_valid(self, time_limit=5):
        # Used to check OTP expiry and registration time limit
        return now() < self.created_at + timedelta(minutes=time_limit)

    def __str__(self):
        return f"Password reset OTP for {self.email}: {self.otp}"

    @staticmethod
    def generate_otp():
        return str(random.randint(1000, 9999))

    def refresh_otp(self):
        self.otp = self.generate_otp()
        self.created_at = now()
        self.is_verified = False
        self.save()
        return self.otp
    


class DiscountBase(models.Model):
    discount = models.PositiveIntegerField(
        validators=[MinValueValidator(0), MaxValueValidator(100)],
        help_text="Discount as a percentage (0-100)."
    )
    original_price = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        default=0.00,
        validators=[MinValueValidator(0.00)],
        help_text="Original price before discount."
    )

    class Meta:
        abstract = True

    def __str__(self):
        return f"Discount - {self.discount}%"

    @property
    def discounted_price(self):
        discount_amount = (Decimal(self.discount) / Decimal(100)) * self.original_price
        price = self.original_price - discount_amount
        # Convert to integer if there are no decimal places
        return int(price) if price == price.to_integral() else price

    @property
    def formatted_original_price(self):
        # Convert to integer if it has no decimal portion
        return int(self.original_price) if self.original_price == self.original_price.to_integral() else self.original_price

    def clean(self):
        # Validate discount range and original price
        if not (0 <= self.discount <= 100):
            raise ValidationError("Discount must be between 0 and 100 percent.")
        if self.original_price < 0:
            raise ValidationError("Original price must be a positive value.")

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)

class Discount(DiscountBase):
    class Meta:
        verbose_name = "Discount"
        verbose_name_plural = "Discounts"

class CorporateDiscount(DiscountBase):
    class Meta:
        verbose_name = "Corporate Discount"
        verbose_name_plural = "Corporate Discounts"

class MentorshipDiscount(DiscountBase):
    class Meta:
        verbose_name = "Mentorship Discount"
        verbose_name_plural = "Mentorship Discounts"



class MentorshipCorporateTrainingBase(models.Model):
    STATUS_CHOICES = (
        ('Applied', 'Applied'),
        ('Select', 'Select'),
        ('Pending', 'Pending'),
        ('Reject', 'Reject'),
        ('EXPIRE', 'EXPIRE'),
        ('DirectSelect', 'DirectSelect'),
    )

    PROGRAM_STATUS_CHOICES = (
        ('Running', 'Running'),
        ('Hold', 'Hold'),
        ('Completed', 'Completed'),
        ('Applied', 'Applied'),
    )

    register = models.ForeignKey('Account', on_delete=models.CASCADE, related_name="%(class)ss")
    unique = models.CharField(max_length=10, unique=True, null=True, blank=True)
    candidate_status = models.CharField(max_length=12, choices=STATUS_CHOICES, default='Applied')
    course_name = models.CharField(max_length=12, null=False,default="Unknown")
    # year_of_Admission = models.CharField(max_length=12, null=False,default="Unknown")
    # current_year = models.IntegerField(max_length=12, null=False,default="Unknown")
    year_of_Admission = models.IntegerField(null=False, default=0)

    current_year = models.IntegerField(null=False, default=0)
    passing_year = models.IntegerField(null=False, default=0)
    applied = models.BooleanField(default=False)
    upload_date = models.DateTimeField(auto_now_add=True,null=True)
    program_status = models.CharField(max_length=12, choices=PROGRAM_STATUS_CHOICES, default='Applied')

    class Meta:
        abstract = True

    def __str__(self):
        return f"{self.__class__.__name__} - {self.register.email}"

    def save(self, *args, **kwargs):
        # Generate a sequential unique ID if `unique` field is blank or null
        if not self.unique:
            # Determine the prefix based on the model class
            if isinstance(self, Mentorship):
                prefix = 'M'
            elif isinstance(self, CorporateTraining):
                prefix = 'CT'
            else:
                raise ValidationError(f"Unsupported model for unique ID generation: {self.__class__.__name__}")

            # Fetch the last record of the same class and generate the next unique ID
            last_record = type(self).objects.order_by('-unique').first()
            if last_record and last_record.unique and last_record.unique[2:].isdigit():
                # Extract the numeric part from the unique field and increment it
                last_number = int(last_record.unique[2:])
                new_number = last_number + 1
            else:
                # Start from 1 if no records exist or the unique field is not formatted as expected
                new_number = 1

            # Format the new unique ID with leading zeros (e.g., M0000001, CT0000001)
            self.unique = f"{prefix}{new_number:07d}"

        super().save(*args, **kwargs)
        

    @classmethod
    def get_by_unique(cls, unique):
        try:
            register = Account.get_by_unique(unique)
            return cls.objects.filter(register=register)
        except Account.DoesNotExist:
            raise ValidationError('Register with the given unique ID does not exist.')


class Mentorship(MentorshipCorporateTrainingBase):
    class Meta:
        verbose_name = "Mentorship"
        verbose_name_plural = "Mentorships"


class CorporateTraining(MentorshipCorporateTrainingBase):
    class Meta:
        verbose_name = "Corporate Training"
        verbose_name_plural = "Corporate Trainings"





class TrainingProgram(models.Model):
    # register = models.ForeignKey(Register, on_delete=models.CASCADE, related_name="training_details", null=True)
    training_program = models.CharField(max_length=255)
    duration = models.CharField(max_length=255)
    original_price = models.PositiveIntegerField()
    discount_percentage = models.PositiveIntegerField(validators=[MinValueValidator(0), MaxValueValidator(100)], help_text="Discount as a percentage (0-100).")
    upload_date = models.DateTimeField(auto_now_add=True,null=True)
    company_name = models.CharField(max_length=255,null=False, blank=False,)  # Add company name field
    training_description = models.TextField(null=False, blank=False)  # Add training description field
    skills_you_will_gain = models.TextField(null=False, blank=False)  # Add skills you will gain field
    What_you_Will_learm = models.TextField(default="",null=False, blank=False)  # Add training description field
   

    @property
    def discounted_price(self):
        discount_amount = (Decimal(self.discount_percentage) / Decimal(100)) * self.original_price
        return self.original_price - discount_amount

    def clean(self):
        super().clean()
        # Ensure discount is between 0 and 100
        if not (0 <= self.discount_percentage <= 100):
            raise ValidationError("Discount percentage must be between 0 and 100.")

    def __str__(self):
        return self.training_program




class BaseModel(models.Model):
    
    PAYMENT_STATUS_CHOICES = (
        ('Not Enroll', 'Not Enroll'),
        ('Enroll Pending', 'Enroll Pending'),
        ('Enrolled', 'Enrolled'),
    )

    payment_status = models.CharField(max_length=15, choices=PAYMENT_STATUS_CHOICES, default='Not Enroll')
    time_end = models.DateTimeField(blank=True, null=True)

    class Meta:
        abstract = True

    def save(self, *args, **kwargs):
        if not self.pk:
            self.time_end = timezone.now()
        super().save(*args, **kwargs)

class TrainingProgramApplication(BaseModel):
    applied_choices = [
        ('Running', 'Running'),
        ('Hold', 'Hold'),
        ('Completed', 'Completed'),
        ('Applied', 'Applied'),
    ]
    register = models.ForeignKey(Account, on_delete=models.CASCADE, related_name="training_details", null=True)
    TrainingProgram = models.ForeignKey(TrainingProgram, on_delete=models.CASCADE, related_name="training_details", null=True)
    applied = models.CharField(max_length=20, choices=applied_choices, default='Not Applied')
    unique_id = models.CharField(max_length=10, unique=True, editable=False, null=True, blank=True)  # The custom unique ID

    def save(self, *args, **kwargs):
        if not self.unique_id:  # Only generate ID if it doesn't exist
            last_application = TrainingProgramApplication.objects.all().order_by('id').last()
            if last_application:
                last_id = last_application.unique_id
                # Extract number from last ID and increment it
                last_number = int(last_id[2:])  # Assuming the format is TI followed by 6 digits
                new_number = last_number + 1
                self.unique_id = f"TI{new_number:06d}"  # Format with leading zeros, e.g., TI000002
            else:
                self.unique_id = "TI000001"  # First unique ID if no records exist
        super(TrainingProgramApplication, self).save(*args, **kwargs)

    def __str__(self):
        return f"{self.register} - {self.TrainingProgram} ({self.applied})"
    



class LiveProjectHub(models.Model):
    # register = models.ForeignKey(Register, on_delete=models.CASCADE, related_name="training_details", null=True)
    LiveProjectHub_program = models.CharField(max_length=255)
    duration = models.CharField(max_length=255)
    original_price = models.PositiveIntegerField()
    discount_percentage = models.PositiveIntegerField(validators=[MinValueValidator(0), MaxValueValidator(100)], help_text="Discount as a percentage (0-100).")
    upload_date = models.DateTimeField(auto_now_add=True,null=True)
    company_name = models.CharField(max_length=255,null=False, blank=False,)  # Add company name field
    LiveProjectHub_program_description = models.TextField(null=False, blank=False)  # Add training description field
    skills_you_will_gain = models.TextField(null=False, blank=False)  # Add skills you will gain field
    What_you_Will_learm = models.TextField(default="",null=False, blank=False)  # Add training description field
   

    @property
    def discounted_price(self):
        discount_amount = (Decimal(self.discount_percentage) / Decimal(100)) * self.original_price
        return self.original_price - discount_amount

    def clean(self):
        super().clean()
        # Ensure discount is between 0 and 100
        if not (0 <= self.discount_percentage <= 100):
            raise ValidationError("Discount percentage must be between 0 and 100.")

    def __str__(self):
        return self.LiveProjectHub_program










class LiveProjectHubApplication(BaseModel):
    applied_choices = [
        ('Running', 'Running'),
        ('Hold', 'Hold'),
        ('Completed', 'Completed'),
        ('Applied', 'Applied'),
    ]
    register = models.ForeignKey(Account, on_delete=models.CASCADE, related_name="LiveProject_details", null=True)
    LiveProjectHub = models.ForeignKey(LiveProjectHub, on_delete=models.CASCADE, related_name="LiveProject_details", null=True)
    applied = models.CharField(max_length=20, choices=applied_choices, default='Not Applied')
    unique_id = models.CharField(max_length=10, unique=True, editable=False, null=True, blank=True)  # The custom unique ID

    def save(self, *args, **kwargs):
        if not self.unique_id:  # Only generate ID if it doesn't exist
            last_application = LiveProjectHubApplication.objects.all().order_by('id').last()
            if last_application:
                last_id = last_application.unique_id
                # Extract number from last ID and increment it
                last_number = int(last_id[2:])  # Assuming the format is TI followed by 6 digits
                new_number = last_number + 1
                self.unique_id = f"LP{new_number:06d}"  # Format with leading zeros, e.g., TI000002
            else:
                self.unique_id = "LP000001"  # First unique ID if no records exist
        super(LiveProjectHubApplication, self).save(*args, **kwargs)

    def __str__(self):
        return f"{self.register} - {self.LiveProjectHub} ({self.applied})"







    











    